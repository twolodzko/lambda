open Errors
open Eval
open Reader
open Term

let show t =
  Printf.printf "# ↪ %s\n" (string_of_term t)

let read_eval lexer =
  let t = read lexer in
  match eval t with
    | exception err ->
        Printf.printf "Error: %s\n" (string_of_error err)
    | t -> show t

let rec repl lexer =
  print_newline ();
  flush stdout;
  let _ = try
    read_eval lexer
  with End_of_file -> () in
  repl lexer

let eval_file path =
  let read_once lexer =
    let t = read lexer in
    Printf.printf "%s\n" (string_of_term t);
    match eval t with
      | exception err ->
          Printf.eprintf "Error: %s\n" (string_of_error err);
          exit 2
      | _ -> () in
  let rec impl lexer =
    try
      read_once lexer;
      print_newline ();
      impl lexer
    with End_of_file -> () in
  impl (from_file path)

let () =
  if (Array.length Sys.argv) = 1 then (
    print_string "Press ^C to exit\n";
    repl (from_channel stdin)
  ) else (
    for i = 1 to Array.length Sys.argv - 1 do
      eval_file Sys.argv.(i);
    done
  )
