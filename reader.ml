exception Parsing_error

let read lexer =
  let t = try
    Parser.prog Lexer.read lexer
  with Parser.Error ->
    raise Parsing_error
  in match t with
    | Some x -> x
    | None -> raise End_of_file
