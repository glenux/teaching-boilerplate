#!/usr/bin/make -f

## Configure this part if you wish to
DEPLOY_REPO=
DEPLOY_OPTS=
BUILD_DIR=_build
DOCS_PORT=5100
SLIDES_PORT=5200

## Find slides
SLIDES_MD=$(shell find slides \( -name '*.md' ! -name '_*' \))
SLIDES_PDF=$(patsubst slides/%.md,$(BUILD_DIR)/slides/%.pdf,$(SLIDES_MD))

DOCS_IMAGES_DOT=$(shell find docs \( -name '*.dot' ! -name '_*' \))
DOCS_IMAGES_DOT_SVG=$(patsubst docs/%.dot,docs/%.dot.svg,$(DOCS_IMAGES_DOT))

DOCS_IMAGES_CIRCO=$(shell find docs \( -name '*.circo' ! -name '_*' \))
DOCS_IMAGES_CIRCO_SVG=$(patsubst docs/%.circo,docs/%.circo.svg,$(DOCS_IMAGES_CIRCO))
DOCS_IMAGES_SVG=$(DOCS_IMAGES_DOT_SVG) $(DOCS_IMAGES_CIRCO_SVG)

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

images: $(DOCS_IMAGES_SVG) ## build images
	@echo Dot: $(DOCS_IMAGES_DOT)
	@echo Circo: $(DOCS_IMAGES_CIRCO)
	@echo Built: $(DOCS_IMAGES_SVG)
.PHONY: images

%.dot.svg: %.dot
	dot -Tsvg $< > $@

%.circo.svg: %.circo
	circo -Tsvg $< > $@

watch: ## run development server
	pipenv run honcho start 

watch-docs-internal:
	pipenv run mkdocs serve --dev-addr 0.0.0.0:$(DOCS_PORT)

watch-slides-internal:
	PORT=$(SLIDES_PORT) npx marp --engine $$(pwd)/.marp/engine.js --html --theme $$(pwd)/.marp/theme.css -w slides -s

watch-slides: ## run development server for PDF slides
	pipenv run honcho start slides

watch-docs: ## run development server for static docs site
	pipenv run honcho start docs toc

serve: watch
serve-slides: watch-slides
serve-docs: watch-docs

.PHONY: watch watch-slides watch-docs watch-slides-internal watch-docs-internal serve serve-docs serve-slides


tocupdate:
	while inotifywait -q -e move -e modify -e create -e attrib -e delete -e moved_to -r docs ; do \
		sleep 0.2 ; \
		make images ; \
		pipenv run ./scripts/update-toc ; \
	done

$(BUILD_DIR)/slides/%.pdf: slides/%.md 
	mkdir -p $(BUILD_DIR)/slides
	npx marp --allow-local-files \
	 	 --engine $$(pwd)/.marp/engine.js \
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

