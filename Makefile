# RxInferServer.jl Makefile

.PHONY: help docs docs-serve docs-clean docs-build deps test clean openapi-endpoints format check-format generate-client generate-server generate-all

# Colors for terminal output
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

# Default target
.DEFAULT_GOAL := help

## Show help for each of the Makefile targets
help:
	@echo ''
	@echo 'RxInferServer.jl Makefile ${YELLOW}targets${RESET}:'
	@echo ''
	@echo '${GREEN}Documentation commands:${RESET}'
	@echo '  ${YELLOW}docs${RESET}                 Build the documentation (same as docs-build)'
	@echo '  ${YELLOW}docs-build${RESET}           Build the documentation'
	@echo '  ${YELLOW}docs-serve${RESET}           Serve documentation locally for preview in browser'
	@echo '  ${YELLOW}docs-clean${RESET}           Clean the documentation build directory'
	@echo ''
	@echo '${GREEN}Development commands:${RESET}'
	@echo '  ${YELLOW}deps${RESET}                 Install project dependencies'
	@echo '  ${YELLOW}test${RESET}                 Run project tests'
	@echo '  ${YELLOW}openapi-endpoints${RESET}    Show RxInferServerOpenAPI module documentation'
	@echo '  ${YELLOW}generate-client${RESET}      Generate OpenAPI client code'
	@echo '  ${YELLOW}generate-server${RESET}      Generate OpenAPI server code'
	@echo '  ${YELLOW}generate-all${RESET}         Generate both OpenAPI client and server code'
	@echo '  ${YELLOW}clean${RESET}                Clean all generated files'
	@echo ''
	@echo '${GREEN}Formatting commands:${RESET}'
	@echo '  ${YELLOW}format${RESET}               Format Julia code (overwrites files)'
	@echo '  ${YELLOW}check-format${RESET}         Check Julia code formatting (does not overwrite files)'
	@echo ''
	@echo '${GREEN}Help:${RESET}'
	@echo '  ${YELLOW}help${RESET}                 Show this help message'
	@echo ''

## Documentation commands:
docs: docs-build ## Build the documentation (same as docs-build)

docs-build: ## Build the documentation
	julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'
	julia --project=docs docs/make.jl

docs-serve: ## Serve documentation locally for preview in browser (requires LiveServer.jl installed globally)
	julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(path=pwd())); Pkg.instantiate()'
	julia --project=docs -e 'using LiveServer; servedocs()'

docs-clean: ## Clean the documentation build directory
	rm -rf docs/build/
	rm -rf docs/src/openapi/

## Development commands:
deps: ## Install project dependencies
	julia -e 'using Pkg; Pkg.instantiate()'

test: ## Run project tests
	julia -e 'using Pkg; Pkg.activate("."); Pkg.test()'

openapi-endpoints: ## Show RxInferServerOpenAPI module documentation (methods to implement)
	julia -e 'using Pkg; Pkg.activate("."); using RxInferServer; println(@doc(RxInferServer.RxInferServerOpenAPI))'

generate-client: ## Generate OpenAPI client code
	./generate-client.sh

generate-server: ## Generate OpenAPI server code
	./generate-server.sh

generate-all: generate-client generate-server ## Generate both OpenAPI client and server code

clean: docs-clean ## Clean all generated files

# Formatting commands:
scripts-deps: ## Install dependencies for the scripts
	julia --project=scripts -e 'using Pkg; Pkg.instantiate()'

format: scripts-deps ## Format Julia code
	julia --project=scripts scripts/formatter.jl --overwrite

check-format: scripts-deps ## Check Julia code formatting
	julia --project=scripts scripts/formatter.jl