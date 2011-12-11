type ('a, 'b) cell = { mutable car: 'a; mutable cdr: 'b }
    
type t = Atom of string
         | Cons of (t, t) cell
         | Func of (t -> t -> t)
         | Lambda of t * t
         | Null
             
let car o =
  match o with
      Cons (c) -> c.car
    | _ -> invalid_arg "Argument to car must be a Cons!"

let cdr o =
  match o with
      Cons (c) -> c.cdr
    | _ -> invalid_arg "Argument to cdr must be a Cons!"

let cons first second = Cons { car = first ; cdr = second }
  
let name o =
  match o with
      Atom (s) -> s
    | _ -> invalid_arg "Argument to name must be an Atom!"
        
