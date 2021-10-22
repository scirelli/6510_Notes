SHELL:=/usr/bin/env bash
.EXPORT_ALL_VARIABLES:

CC=acme
CFLAGS=-v8
DEPS=

.cache/%.prg: %.asm
	$(CC) $(CFLAGS) --outfile $@ $^

test: .cache/test.prg ## Build the project
	@echo 'Done'





.PHONY: clean
clean:
	rm ./.cache/test*

.PHONY: help
help: ## Show help message
	@grep -E '^[[:alnum:]_-]+[[:blank:]]?:.*##' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
