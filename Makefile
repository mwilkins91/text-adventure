.PHONY: all test

all:
	webdev serve;

test:
	cd tests && npm run ci;

