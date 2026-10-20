# Developer task runner. Run `make` (or `make help`) to
# list the available targets.
#
# This repo only deploys the backend: the targets validate
# the stack and the workflow, they never run it locally.

.DEFAULT_GOAL := help

# Same Caddy image as the production stack, read from compose.yaml
CADDY_IMAGE := $(shell sed -n 's/^ *image: *\(caddy:.*\)$$/\1/p' compose.yaml)

# Any 40-hex tag satisfies the compose.yaml interpolation check
DUMMY_TAG := 0000000000000000000000000000000000000000

##@ Quality

.PHONY: check
check: lint-workflow lint-script check-compose check-caddy ## Run every check below

.PHONY: lint-workflow
lint-workflow: ## Lint the GitHub Actions workflow
	actionlint

.PHONY: lint-script
lint-script: ## Lint the VPS deploy script as POSIX sh
	shellcheck -s sh scripts/deploy.sh

.PHONY: check-compose
check-compose: ## Validate compose.yaml
	APP_IMAGE_TAG=$(DUMMY_TAG) docker compose config --quiet

.PHONY: check-caddy
check-caddy: ## Validate the Caddyfile with throwaway certificates
	@certs=$$(mktemp -d); trap 'rm -rf "$$certs"' EXIT; \
		openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
			-subj /CN=api.intothefray.xyz -days 30 \
			-keyout "$$certs/origin-key.pem" -out "$$certs/origin.pem" 2>/dev/null && \
		chmod 644 "$$certs"/*.pem && \
		docker run --rm --quiet \
			-v "$(CURDIR)/Caddyfile:/etc/caddy/Caddyfile:ro" \
			-v "$$certs:/certs:ro" \
			$(CADDY_IMAGE) caddy validate --config /etc/caddy/Caddyfile

##@ Helpers

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} \
		/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(firstword $(MAKEFILE_LIST))
