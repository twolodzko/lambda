open Term

exception Parsing_error

let is_special = function
  | '\\' | '.' | '(' | ')' | '=' | '#' | '\n' -> true
  | _ -> false

let is_whitespace = function
  | ' ' | '\012' | '\t' | '\r' -> true
  | _ -> false

let is_word_end c = is_special c || is_whitespace c

let rec skip_whitespace stm =
  match Stream.peek stm with
    | Some c ->
        if is_whitespace c then (
          Stream.junk stm;
          skip_whitespace stm
        )
    | _ -> ()

let read_var stm =
  skip_whitespace stm;
  let rec impl stm acc =
    match Stream.peek stm with
      | None | Some '\n' -> acc
      | Some c ->
          if is_word_end c then
            acc
          else (
            Stream.junk stm;
            impl stm (acc ^ Char.escaped c)
          )
  in match impl stm "" with
    | "" -> raise Parsing_error
    | x -> x

let rec read stm =
  next stm (read_term stm)
and next stm t =
  skip_whitespace stm;
  match Stream.peek stm with
    | None | Some ')' | Some '\n' -> t
    | Some '=' ->
        Stream.junk stm;
        Def (t, read stm)
    | Some _ -> next stm (App (t, read_term stm))
and read_term stm =
  skip_whitespace stm;
  match Stream.peek stm with
    | None | Some '\n' -> raise End_of_file
    | Some '(' -> (
        Stream.junk stm;
        let t = read stm in
        match Stream.peek stm with
          | Some ')' ->
              Stream.junk stm;
              t
          | _ -> raise Parsing_error
    )
    | Some '\\' ->
        Stream.junk stm;
        read_abstraction stm
    | Some _ -> Var (read_var stm)
and read_abstraction stm =
  let x = read_var stm in
  skip_whitespace stm;
  match Stream.peek stm with
    | None | Some '\n' -> raise Parsing_error
    | Some '.' ->
        Stream.junk stm;
        Abs (x, read stm)
    | Some _ -> Abs (x, read_abstraction stm)
