.PHONY: test example
test:
	busted test/

example:
	lua readme_example.lua
