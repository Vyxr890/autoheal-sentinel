lint:
	shellcheck bin/*.sh lib/*.sh install.sh

test:
	bats tests/

install:
	./install.sh

run:
	./bin/autoheal-sentinel.sh

.PHONY: lint test install run
