open Eval
open Term
open Reader
open Reduce
open Lexing

let parse_eval s =
    eval (read (from_string s))

let%test _ =
  parse_eval "x"
  = Var "x"
let%test _ =
  parse_eval "\\ x . x"
  = Abs ("x", Var "x")
let%test _ =
  parse_eval "(\\ x . x) y"
  = Var "y"
let%test _ =
  parse_eval "(\\ x . \\ y . x y) a b"
  = App (Var "a", Var "b")
let%test _ =
  parse_eval "(\\ x y . x y) a b"
  = App (Var "a", Var "b")
let%test _ =
  parse_eval "(\\ x . t) u"
  = Var "t"
let%test _ =
  parse_eval "(\\ x y . x y) (\\ x . x) b"
  = Var "b"
let%test _ =
  parse_eval "(\\ x . y)((\\ y . y) (\\ z . z))"
  = Var "y"
let%test _ =
  parse_eval "(\\ b x y . b x y) (\\ x y . x) t u"
  = Var "t"
let%test _ =
  let _ = parse_eval "a = (\\x.x) ok" in
  (Env.find "a" !env) = Var "ok"
let%test _ =
  let _ = parse_eval "a b = a b" in true
let%test _ =
  let _ = parse_eval "\\x.x = \\y.y" in true
let%test _ =
  let _ = parse_eval "\\x.x = (\\y.y) (\\z.z)" in true
let%test _ =
  let _ = parse_eval "(\\y.y) (\\z.z) = \\x.x" in true
let%test _ =
  try
    let _ = parse_eval "x = 1" in
    let _ = parse_eval "x = 1" in
    let _ = parse_eval "x = 2" in false
  with Not_equal _ -> true

let%test _ =
  equal
    (read (from_string "x"))
    (read (from_string "x"))
let%test _ =
  not (equal
    (read (from_string "x"))
    (read (from_string "y")))
let%test _ =
  equal
    (read (from_string "t u"))
    (read (from_string "t u"))
let%test _ =
  not (equal
    (read (from_string "u t"))
    (read (from_string "t u")))
let%test _ =
  equal
    (read (from_string "\\ x . x"))
    (read (from_string "\\ x . x"))
let%test _ =
  equal
    (read (from_string "\\ x . x"))
    (read (from_string "\\ y . y"))
let%test _ =
  equal
    (read (from_string "\\ x y . x y"))
    (read (from_string "\\ y x . y x"))
let%test _ =
  equal
    (read (from_string "\\ x y . x (y z)"))
    (read (from_string "\\ y x . y (x z)"))
let%test _ =
  equal
    (read (from_string "(\\ x . x) z"))
    (read (from_string "(\\ y . y) z"))
