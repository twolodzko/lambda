open Eval
open Reader
open Term
open Lexing

let print_not_equal x x' =
  Printf.printf
    "Error: %s and %s are not the same\n"
    (string_of_term x)
    (string_of_term x')

let print_unexpected x =
  Printf.printf
    "Error: unexpected argument %s\n"
    (string_of_term x)

let read_eval lexer =
  let t = read lexer in
  try
    let _ = eval t in ()
  with
    | Not_equal (x, x') ->
        print_not_equal x x'
    | Unexpected x ->
        print_unexpected x

let rec repl lexer =
  print_newline ();
  flush stdout;
  let _ = try
    read_eval lexer
  with End_of_file -> () in
  repl lexer

let eval_file path =
  let rec impl lexer =
    try
      let t = read lexer in
      Printf.printf "%s\n" (string_of_term t);
      match eval t with
        | exception Not_equal (x, x') ->
            print_not_equal x x';
        | exception Unexpected x ->
            print_unexpected x;
        | _ -> ();
      print_newline ();
      impl lexer
    with End_of_file -> () in
  impl (from_channel (open_in path))

let () =
  if (Array.length Sys.argv) = 1 then (
    print_string "Press ^C to exit\n";
    repl (from_channel stdin)
  ) else (
    for i = 1 to Array.length Sys.argv - 1 do
      eval_file Sys.argv.(i);
    done
  )
