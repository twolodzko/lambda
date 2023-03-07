open Term

exception Unexpected of term

module Env = Map.Make(String)
let env = ref Env.empty

(* The code below is adapted from "Program = Proof" by Samuel Mimram *)

let fresh =
  let counter = ref 0 in
  fun x ->
    incr counter;
    let x' = List.hd (String.split_on_char '@' x) in
    Printf.sprintf "%s@%d" x' !counter

let rec subst x t = function
  | Var y -> if y = x then t else Var y
  | App (u, v) -> App (subst x t u, subst x t v)
  | Abs (y, u) ->
      let y' = fresh y in
      let u = subst y (Var y') u in
      Abs (y', subst x t u)
  | Def _ as x -> raise (Unexpected x)

let rec reduce_cbv = function
  | Var x -> (
    match Env.find_opt x !env with
      | Some v -> v
      | None -> Var x
  )
  | Abs (x, t) -> Abs (x, t)
  | App (t, u) -> (
      match reduce_cbv t with
        | Abs (x, t') -> subst x (reduce_cbv u) t'
        | t -> App (t, reduce_cbv u)
  )
  | Def _ as x -> raise (Unexpected x)

let rec reduce_ao = function
  | Var x -> (
    match Env.find_opt x !env with
      | Some v -> v
      | None -> Var x
  )
  | Abs (x, t) -> Abs (x, reduce_ao t)
  | App (t, u) -> (
      match reduce_ao t with
        | Abs (x, t') -> subst x (reduce_ao u) t'
        | t -> App (t, reduce_ao u)
  )
  | Def _ as x -> raise (Unexpected x)

let rec reduce_cbn = function
  | Var x -> (
    match Env.find_opt x !env with
      | Some v -> v
      | None -> Var x
  )
  | Abs (x, t) -> Abs (x, t)
  | App (t, u) -> (
      match reduce_cbn t with
        | Abs (x, t') -> subst x u t'
        | t -> App (t, u)
  )
  | Def _ as x -> raise (Unexpected x)

let rec reduce_no = function
  | Var x -> (
    match Env.find_opt x !env with
      | Some v -> v
      | None -> Var x
  )
  | Abs (x, t) -> Abs (x, reduce_no t)
  | App (t, u) -> (
      match reduce_cbn t with
        | Abs (x, t') -> subst x u t'
        | t -> App (reduce_no t, reduce_no u)
  )
  | Def _ as x -> raise (Unexpected x)

let reduce = reduce_ao

let rec normalize t =
  let u = reduce t in
  if t = u then t else normalize u
