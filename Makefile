.PHONY: all test

test:
	cd tests && npm run ci;
	;

all:
	webdev serve;