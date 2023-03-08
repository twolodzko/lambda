open Reduce
open Term

let rec equal a b =
  match (a, b) with
    | (Var x), (Var x') -> x = x'
    | (App (t, u)), (App (t', u')) -> (equal t t') && (equal u u')
    | Abs (x, t), Abs (x', t') ->
        if x = x' then
          equal t t'
        else
          equal t (subst x' (Var x) t')
    | _ -> false

let assert_equal a b =
  if not (equal a b) then
    raise (Errors.Not_equal (a, b))

let rec eval t =
  match t with
    | Def (x, t) -> eval_def x t
    | _ -> normalize t
and eval_def x t =
  let t' = eval t in
  let _ = match x with
    | Var x -> (
        match Env.find_opt x !env with
          | Some x' ->
              assert_equal x' t'
          | None ->
              env := Env.add x t' !env
    )
    | _ -> assert_equal (eval x) t'
  in t'
