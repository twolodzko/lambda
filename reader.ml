
let read lexer =
  let t = try
    Parser.prog Lexer.read lexer
  with Parser.Error ->
    raise Errors.Parsing_error
  in match t with
    | Some x -> x
    | None -> raise End_of_file

let from_channel = Lexing.from_channel

let from_string = Lexing.from_string

let from_file path =
  (Lexing.from_channel (open_in path))
