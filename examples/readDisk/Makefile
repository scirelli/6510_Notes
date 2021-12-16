SHELL:=/usr/bin/env bash
.EXPORT_ALL_VARIABLES:

all: test.d64

#tr [:lower:] [:upper:] < raw.txt | tr '\n' '\r' > input.txt
testData.txt:
	echo 'HELLO WORLD!' > testData.txt

test.d64: testData.txt
	cc1541 -f 'test' -T SEQ -w ./testData.txt test.d64

.PHONY: clean
clean: ## Remove generated build files
	@rm -f test.d64

.PHONY: help
help: ## Show help message
	@grep -E '^[[:alnum:]_-]+[[:blank:]]?:.*##' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
