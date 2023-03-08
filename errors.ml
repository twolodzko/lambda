open Term

exception Parsing_error
exception Not_equal of term * term
exception Unexpected of term

let string_of_error = function
  | Not_equal (x, x') ->
      Printf.sprintf
        "%s and %s are not the same"
        (string_of_term x)
        (string_of_term x')
  | Unexpected x ->
      Printf.sprintf
        "unexpected argument %s"
        (string_of_term x)
  | err -> raise err
