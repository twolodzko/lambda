
BINARY := "lambda"

# Run unit tests
test: build
	dune runtest

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
