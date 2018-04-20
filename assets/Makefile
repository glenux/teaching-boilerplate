
SCSS=$(wildcard *.scss)
CSS=$(patsubst %.scss,%.css,$(SCSS))

all: build

build: $(CSS)

clean:
	rm -f $(CSS)

%.css: %.scss 
	sass $< > $@


