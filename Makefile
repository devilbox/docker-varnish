# -------------------------------------------------------------------------------------------------
# VARIABLES AND CONFIGURATION
# -------------------------------------------------------------------------------------------------

DOCKERFILES = .
IMAGE = devilbox/varnish


# -------------------------------------------------------------------------------------------------
# DEFAULT TARGET
# -------------------------------------------------------------------------------------------------

## Show this help
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  %-20s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


# -------------------------------------------------------------------------------------------------
# BUILD TARGETS
# -------------------------------------------------------------------------------------------------

## Build all
build: build-4 build-5 build-6
## Rebuild all (without cache)
rebuild: rebuild-4 rebuild-5 rebuild-6

## Build Varnish 4
build-4:
	docker build -t $(IMAGE):4 -f $(DOCKERFILES)/Dockerfile-4 $(DOCKERFILES)
## Build Varnish 5
build-5:
	docker build -t $(IMAGE):5 -f $(DOCKERFILES)/Dockerfile-5 $(DOCKERFILES)
## Build Varnish 6
build-6:
	docker build -t $(IMAGE):6 -f $(DOCKERFILES)/Dockerfile-6 $(DOCKERFILES)

## Rebuild Varnish 4 (without cache)
rebuild-4:
	docker build --no-cache -t $(IMAGE):4 -f $(DOCKERFILES)/Dockerfile-4 $(DOCKERFILES)
## Rebuild Varnish 5 (without cache)
rebuild-5:
	docker build --no-cache -t $(IMAGE):5 -f $(DOCKERFILES)/Dockerfile-5 $(DOCKERFILES)
## Rebuild Varnish 6 (without cache)
rebuild-6:
	docker build --no-cache -t $(IMAGE):6 -f $(DOCKERFILES)/Dockerfile-6 $(DOCKERFILES)


# -------------------------------------------------------------------------------------------------
# TEST TARGETS
# -------------------------------------------------------------------------------------------------

## Test Varnish 4
test-4:
	@$(MAKE) _clean
	@$(MAKE) _start-test VERSION=4
	if ! curl -IsS localhost:8080 | grep 'X-Server' | grep 'Varnish 4'; then \
		curl -IsS localhost:8080 || true; \
		curl -sS localhost:8080 || true; \
		@$(MAKE) _clean; \
		exit 1; \
	fi
	if ! curl -IsS localhost:8080 | grep 'X-Powered-By' | grep Devilbox; then \
		curl -IsS localhost:8080 || true; \
		curl -sS localhost:8080 || true; \
		@$(MAKE) _clean; \
		exit 1; \
	fi
	@$(MAKE) _clean

## Test Varnish 5
test-5:
	@$(MAKE) _clean
	@$(MAKE) _start-test VERSION=5
	if ! curl -IsS localhost:8080 | grep 'X-Server' | grep 'Varnish 5'; then \
		curl -IsS localhost:8080 || true; \
		curl -sS localhost:8080 || true; \
		@$(MAKE) _clean; \
		exit 1; \
	fi
	if ! curl -IsS localhost:8080 | grep 'X-Powered-By' | grep Devilbox; then \
		curl -IsS localhost:8080 || true; \
		curl -sS localhost:8080 || true; \
		@$(MAKE) _clean; \
		exit 1; \
	fi
	@$(MAKE) _clean

## Test Varnish 6
test-6:
	@$(MAKE) _clean
	@$(MAKE) _start-test VERSION=6
	if ! curl -IsS localhost:8080 | grep 'X-Server' | grep 'Varnish 4'; then \
		curl -IsS localhost:8080 || true; \
		curl -sS localhost:8080 || true; \
		@$(MAKE) _clean; \
		exit 1; \
	fi
	if ! curl -IsS localhost:8080 | grep 'X-Powered-By' | grep Devilbox; then \
		curl -IsS localhost:8080 || true; \
		curl -sS localhost:8080 || true; \
		@$(MAKE) _clean; \
		exit 1; \
	fi
	@$(MAKE) _clean


# -------------------------------------------------------------------------------------------------
# PUSH TARGETS
# -------------------------------------------------------------------------------------------------

## Push Varnish 4 to Dockerhub
push-4:
ifndef TAG
	docker push $(IMAGE):4
else
	docker tag $(IMAGE):4 $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)
endif

## Push Varnish 5 to Dockerhub
push-5:
ifndef TAG
	docker push $(IMAGE):5
else
	docker tag $(IMAGE):5 $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)
endif

## Push Varnish 6 to Dockerhub
push-6:
ifndef TAG
	docker push $(IMAGE):6
	@# If no custom tag is specified, Varnish 6 will also push Varnish latest
	docker tag $(IMAGE):6 $(IMAGE):latest
	docker push $(IMAGE):latest
else
	docker tag $(IMAGE):6 $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)
endif


# -------------------------------------------------------------------------------------------------
# INTERNAL HELPER TARGETS
# -------------------------------------------------------------------------------------------------

_clean:
	@cd tests/ && docker-compose stop || true
	@cd tests/ && docker-compose kill || true
	@cd tests/ && docker-compose rm -f || true
	@rm -f tests/.env || true

_start-test:
	while ! docker pull nginx; do sleep 1; done;
	echo "VARNISH_SERVER=$(VERSION)" > tests/.env
	cd tests/ && docker-compose up -d
	sleep 5;
