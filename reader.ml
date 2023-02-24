
type t = Stream

let of_stream stm =
  let rec skip i =
    match Stream.next stm with
      | '\n' -> next i
      | _ -> skip i
  and next i =
    try (
      match Stream.next stm with
        | '\206' as c -> (
            match Stream.peek stm with
              | Some '\187' ->
                  (* \206\187 is "λ" *)
                  Stream.junk stm;
                  Some '\\'
              | _ -> Some c
        )
        | '#' -> skip i
        | s -> Some s
    ) with Stream.Failure -> None
  in Stream.from next

let of_string s =
  of_stream (Stream.of_string s)

let of_channel c =
  of_stream (Stream.of_channel c)
