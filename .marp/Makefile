
all: build

build: theme.css

%.css: %.scss
	cd .. \
		&& npx node-sass --output-style compressed .marp/$< > .marp/$@ \
		|| ( rm -f .marp/$@ && exit 1 )

.PHONY: build

