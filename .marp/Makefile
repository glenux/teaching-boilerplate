
all: build


build: theme.css

%.css: %.scss
	cd .. && npx node-sass --output-style compressed .marp/$< > .marp/$@

.PHONY: build

