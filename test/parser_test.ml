open Parser
open Term
open Reader

let%test _ =
  read (of_string "x")
  = Var "x"
let%test _ =
  read (of_string "foo")
  = Var "foo"
let%test _ =
  try
      let _ = read (of_string "()");
      in false
  with Parsing_error -> true
let%test _ =
  read (of_string "(x)")
  = Var "x"
let%test _ =
  read (of_string "(((x)))")
  = Var "x"
let%test _ =
  read (of_string "t u")
  = App (Var "t", Var "u")
let%test _ =
  read (of_string "(t u)")
  = App (Var "t", Var "u")
let%test _ =
  read (of_string "x (t u)")
  = App (Var "x", App (Var "t", Var "u"))
let%test _ =
  read (of_string "(x t) u")
  = App (App (Var "x", Var "t"), Var "u")
let%test _ =
  read (of_string "\\ x . x")
  = Abs ("x", Var "x")
let%test _ =
  read (of_string "(\\ x . x)")
  = Abs ("x", Var "x")
let%test _ =
  read (of_string "\\ x y . x y")
  = Abs ("x", Abs ("y", App (Var "x", Var "y")))
let%test _ =
  read (of_string "\\x y.x y")
  = Abs ("x", Abs ("y", App (Var "x", Var "y")))
let%test _ =
  read (of_string "\\ x y .(x y)")
  = Abs ("x", Abs ("y", App (Var "x", Var "y")))
let%test _ =
  read (of_string "\\ x . \\ y . x y")
  = Abs ("x", Abs ("y", App (Var "x", Var "y")))
let%test _ =
  read (of_string "(\\ x . x) y")
  = App(Abs ("x", Var "x"), Var "y")
let%test _ =
  read (of_string "(\\ x y . x y) a b")
  = App (App(Abs ("x", Abs("y", App (Var "x", Var "y"))), Var "a"), Var "b")
let%test _ =
  read (of_string "I = \\ x . x")
  = Def (Var "I", Abs ("x", Var "x"))
let%test _ =
  read (of_string "I = (\\ x y . x y) a")
  = Def (Var "I", App (Abs ("x", Abs("y", App(Var "x", Var "y"))), Var "a"))
let%test _ =
  read (of_string "(\\x.x) = (\\y.y)")
  = Def (Abs("x", Var "x"), Abs("y", Var "y"))
