open Eval
open Parser
open Reader
open Term

let print_not_equal x x' =
  Printf.printf
    "Error: %s and %s are not the same\n\n"
    (string_of_term x)
    (string_of_term x')

let print_unexpected x =
  Printf.printf
    "Error: unexpected argument %s\n\n"
    (string_of_term x)

let rec repl stm =
  flush stdout;
  let _ = try
    match eval (read stm) with
      | exception Not_equal (x, x') ->
          print_not_equal x x'
      | exception Unexpected x ->
          print_unexpected x
      | _ -> print_newline ();
  with End_of_file ->
    Stream.junk stm
  in repl stm

let eval_file path =
  let rec impl stm =
    skip_whitespace stm;
    match  Stream.peek stm with
      | Some '\n' ->
          Stream.junk stm;
          impl stm
      | _ -> ();
    try
      let t = read stm in
      Printf.printf "%s\n" (string_of_term t);
      match eval t with
        | exception Not_equal (x, x') ->
            print_not_equal x x';
            exit 1
        | _ -> ();
      print_newline ();
      Stream.junk stm;
      impl stm
    with End_of_file -> ()
  in impl (of_channel (open_in path))

let () =
  if (Array.length Sys.argv) = 1 then (
    print_string "Press ^C to exit\n\n";
    repl (of_channel stdin)
  ) else (
    for i = 1 to Array.length Sys.argv - 1 do
      eval_file Sys.argv.(i);
    done
  )
