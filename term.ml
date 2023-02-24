
exception Unreachable

type term =
  | Var of string
  | App of term * term
  | Abs of string * term
  | Def of term * term

let rec string_of_term = function
  | Var x -> x
  | App ((Abs _ as t), (Abs _ as u)) -> Printf.sprintf "(%s) (%s)" (string_of_term t) (string_of_term u)
  | App (Abs _ as t, u) -> Printf.sprintf "(%s) %s" (string_of_term t) (string_of_term u)
  | App (t, Var u) -> Printf.sprintf "%s %s" (string_of_term t) u
  | App (t, u) -> Printf.sprintf "%s (%s)" (string_of_term t) (string_of_term u)
  | Abs _ as t -> Printf.sprintf "λ %s" (string_of_abs t)
  | Def (x, t) -> Printf.sprintf "%s = %s" (string_of_term x) (string_of_term t)
and string_of_abs = function
  | Abs (x, (Abs _  as u)) -> Printf.sprintf "%s %s" x (string_of_abs u)
  | Abs (x, u) -> Printf.sprintf "%s . %s" x (string_of_term u)
  | t -> string_of_term t
