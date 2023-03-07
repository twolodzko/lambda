(lang dune 3.4)

(name lambda)

(generate_opam_files true)

(package
 (name lambda)
 (depends ocaml dune))

(using menhir 2.0)

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
