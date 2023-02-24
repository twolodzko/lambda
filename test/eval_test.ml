open Eval
open Term
open Parser
open Reader

let parse_eval s =
    eval (read (of_string s))

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
  equal
    (read (of_string "x"))
    (read (of_string "x"))
let%test _ =
  not (equal
    (read (of_string "x"))
    (read (of_string "y")))
let%test _ =
  equal
    (read (of_string "t u"))
    (read (of_string "t u"))
let%test _ =
  not (equal
    (read (of_string "u t"))
    (read (of_string "t u")))
let%test _ =
  equal
    (read (of_string "\\ x . x"))
    (read (of_string "\\ x . x"))
let%test _ =
  equal
    (read (of_string "\\ x . x"))
    (read (of_string "\\ y . y"))
let%test _ =
  equal
    (read (of_string "\\ x y . x y"))
    (read (of_string "\\ y x . y x"))
let%test _ =
  equal
    (read (of_string "\\ x y . x (y z)"))
    (read (of_string "\\ y x . y (x z)"))
let%test _ =
  equal
    (read (of_string "(\\ x . x) z"))
    (read (of_string "(\\ y . y) z"))
