
BINARY := "lambda"

# Run tests
test: unit-tests integration-tests

# Run unit tests
unit-tests: build
	dune runtest

# Run integration tests
integration-tests: build
	set -e
	./{{BINARY}} examples/core.ch    1>/dev/null
	./{{BINARY}} examples/logic.ch   1>/dev/null
	./{{BINARY}} examples/numbers.ch 1>/dev/null
	./{{BINARY}} examples/pairs.ch   1>/dev/null

# Start the REPL
repl: build
	@ ./{{BINARY}}

# Build the module
build:
	dune build
	@ cp -f _build/default/main.exe {{BINARY}}

# Cleanup
clean:
	@ rm -rf _build
	@ rm -rf {{BINARY}}
	@ rm -rf *.opam
