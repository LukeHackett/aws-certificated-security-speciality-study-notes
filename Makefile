
.PHONY: all
all: lint

.PHONY: lint
lint:
	cspell lint --config cspell.json --relative "**/*md" 
