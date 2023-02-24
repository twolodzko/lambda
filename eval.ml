open Term

exception Not_equal of term * term
exception Unexpected of term

let fresh =
  let counter = ref 0 in
  fun x ->
    incr counter;
    let x' = List.hd (String.split_on_char '@' x) in
    Printf.sprintf "%s@%d" x' !counter

module Env = Map.Make(String)
let env = ref Env.empty

let rec subst x t = function
  | Var y -> if y = x then t else Var y
  | App (u, v) -> App (subst x t u, subst x t v)
  | Abs (y, u) ->
      let y' = fresh y in
      let u = subst y (Var y') u in
      Abs (y', subst x t u)
  | Def _ as x -> raise (Unexpected x)

let rec reduce = function
  | Var x -> (
    match Env.find_opt x !env with
      | Some v -> v
      | None -> Var x
  )
  | App (t, u) -> (
      match reduce t with
        | Abs (x, t') -> subst x (reduce u) t'
        | t -> App (t, reduce u)
  )
  | Abs (t, u) -> Abs (t, reduce u)
  | Def _ as x -> raise (Unexpected x)

let show t =
  Printf.printf "# ↪ %s\n" (string_of_term t)

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

let rec eval t =
  match t with
    | App (Abs _, _) ->
        show t;
        eval_term t
    | Def (x, t) -> eval_def x t
    | _ -> eval_term t
and eval_term t =
  let t' = reduce t in
  if t = t' then (
    show t';
    t'
  ) else
    eval t'
and eval_def x t =
  let t' = eval t in
  let _ = match x with
    | Var x -> (
        match Env.find_opt x !env with
          | Some x' ->
              if not (equal x' t') then
                raise (Not_equal (x', t'))
          | None ->
              env := Env.add x t' !env
    )
    | _ ->
        let x' = eval x in
        if not (equal x' t') then
          raise (Not_equal (x', t'))
  in t'
