.PHONY: all test clean

test:
	bash test/prepare.sh
	bats test/commands_test.bats
