#!/usr/bin/make -f

THEME=gyr
THEME_OPT=-t $(THEME)

REVEALJS_THEMES=node_modules/reveal.js/css/theme
REVEALJS_DIR=node_modules/reveal.js

BUILD_DIR=build

SLIDES_DIR=slides
SLIDES_MD=$(wildcard $(SLIDES_DIR)/**/*.md)
SLIDES_PDF=$(patsubst $(SLIDES_DIR)/%,$(BUILD_DIR)/%,$(patsubst %.md,%.pdf,$(SLIDES_MD)))
SLIDES_HTML=$(patsubst $(SLIDES_DIR)/%,$(BUILD_DIR)/%,$(patsubst %.md,%.html,$(SLIDES_MD)))

NAME=$(shell basename "$$(pwd)")

REVEALMD=node_modules/.bin/reveal-md
all: live

configure: configure-assets configure-reveal configure-style

configure-assets:
	$(MAKE) -C assets build 

configure-reveal:
	npm install reveal-md # -v 0.0.19
	npm install node-sass

configure-style:
	cp -a themes/$(THEME).scss $(REVEALJS_THEMES)/source
	cd $(REVEALJS_DIR) && ../.bin/node-sass \
		css/theme/source/$(THEME).scss \
		css/theme/$(THEME).css \

zip:
	rm -f "../$(NAME)-latest.zip"
	(git ls-files ; find assets) |grep -v '^ext' | zip -r "../$(NAME)-latest.zip" -@

live:
	$(REVEALMD) --disable-auto-open --host 0.0.0.0 $(THEME_OPT) $(SLIDES_DIR)

.PHONY: build-pdf build-html
build-pdf: $(SLIDES_PDF)

build-html: $(SLIDES_HTML)


$(BUILD_DIR)/%.pdf: $(SLIDES_DIR)/%.md
	mkdir -p "$$(dirname "$@")"
	docker run --rm --net=host -v "`pwd`:/slides" astefanutti/decktape http://localhost:1948/$(<:slides/%=%) --pause 500 /slides/$@
	touch -a -r "$<" "$@"

$(BUILD_DIR)/%.html: $(SLIDES_DIR)/%.md
	mkdir -p "$$(dirname "$@")"
	test -d "$$(dirname "$<")/images" \
		&& rsync -a "$$(dirname "$<")/images/" "$$(dirname "$@")/images/" \
		|| true
	pandoc -f markdown+emoji -t html -o "$@" "$<"
	touch -a -r "$<" "$@"

clean: clean-pdf clean-html

clean-pdf:
	rm -f $(BUILD_DIR)/**/*.pdf

clean-html:
	rm -f $(BUILD_DIR)/**/*.html

tasklist:
	watch "find slides/ -type f -name '*.md' |egrep -v '(template-|\.DONE\.md)' |sort"

