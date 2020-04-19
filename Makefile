#!/usr/bin/make -f

## Configure this part if you wish to
DEPLOY_REPO=
DEPLOY_OPTS=
BUILD_DIR=_build

## Find slides
SLIDES_MD=$(shell find slides \( -name '*.md' ! -name '_*' \))
SLIDES_PDF=$(patsubst slides/%.md,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_MD))

all: help

##
## Install prerequisites
##

prepare: prepare-slides prepare-docs ## install prerequisites

prepare-slides: ## install prerequisites for PDF slides only
	npm install

prepare-docs: ## install prerequisites for static docs site only
	pipenv install

.PHONY: prepare prepare-slides prepare-docs


watch: ## run development server
	pipenv run honcho start 

watch-slides: ## run development server for PDF slides
	npx marp --engine $$(pwd)/.marp/engine.js --html --theme $$(pwd)/.marp/theme.css -w slides -s

watch-docs: ## run development server for static docs site
	pipenv run mkdocs serve --dev-addr 0.0.0.0:5001

serve: watch
serve-slides: watch-slides
serve-docs: watch-docs

.PHONY: watch watch-slides watch-docs serve serve-docs serve-slides


tocupdate:
	while inotifywait -q -e move -e modify -e create -e attrib -e delete -r docs ; do \
		sleep 1 ; \
		pipenv run ./scripts/update-toc ; \
	done

$(BUILD_DIR)/slides/%.pdf: slides/%.md 
	mkdir -p $(BUILD_DIR)/slides
	npx marp --allow-local-files \
	 	 --engine $$(pwd)/engine.js \
	 	 --html \
	 	 --theme theme.css \
	 	 $< \
	 	 -o $@


##
## Build final documents 
##
## slides => PDF
## docs   => static web site
##

build: build-docs build-slides ## build all documents

build-slides: $(SLIDES_PDF) $(SLIDES_MD) ## build PDF slides only

build-docs:  ## build static docs site only
	pipenv run mkdocs build --site-dir $(BUILD_DIR)/docs

.PHONY: build build-slides

deploy-docs: ## deploy static docs site to github
	git push $(DEPLOY_REPO)
	pipenv run mkdocs gh-deploy $(DEPLOY_OPTS)

help: ## print this help
	@echo "Usage: make <target>"
	@echo ""
	@echo "With one of following targets:"
	@echo ""
	@awk 'BEGIN {FS = ":.*?## "} \
	  /^[a-zA-Z_-]+:.*?## / \
	  { sub("\\\\n",sprintf("\n%22c"," "), $$2); \
		printf("\033[36m%-20s\033[0m %s\n", $$1, $$2); \
	  }' $(MAKEFILE_LIST)
	@echo ""


##
## Clean
##

clean: clean-slides clean-docs # remove generated documents

clean-slides:
	rm -fr $(BUILD_DIR)/slides # remove generated PDF slides

clean-docs:
	rm -fr $(BUILD_DIR)/docs # remove generated static docs site

.PHONY: clean clean-slides clean-docs

