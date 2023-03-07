open Term

let%test _ =
    string_of_term (Var "foo")
    = "foo"
let%test _ =
    string_of_term (App (Var "x", Var "y"))
    = "x y"
let%test _ =
    string_of_term (App (App (Var "x", Var "y"), Var "z"))
    = "x y z"
let%test _ =
    string_of_term (App (Var "x", App (Var "y", Var "z")))
    = "x (y z)"
let%test _ =
    string_of_term (Abs ("x", Var "x"))
    = "λ x . x"
let%test _ =
    string_of_term (Abs ("x", Abs ("y", App (Var "x", Var "y"))))
    = "λ x y . x y"
let%test _ =
    string_of_term (App
    (App
        (App
        (Abs ("b", Abs ("x", Abs ("y", App (App (Var "b", Var "x"), Var "y")))),
        Abs ("x", Abs ("y", Var "x"))),
        Var "t"),
    Var "u"))
    = "(λ b x y . b x y) (λ x y . x) t u"
let%test _ =
    string_of_term (Def (Var "I", Abs ("x", Var "x" )))
    = "I = λ x . x"
