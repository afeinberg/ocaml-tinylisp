open Sexp
open Environment

let tee = (Atom "#T")

let nil = cons Null Null

let fn_car args _ = car (car args)

let fn_cdr args _ = cdr (car args)

let fn_quote args _ = car args

let fn_cons args _ =
  let lst = cons (car args) Null  in

  let rec loop a =
    match a with
        Cons (_) ->
          begin
            append lst (car a) ;
            loop (cdr a)
          end
      | _ -> lst
  in
    loop (car (cdr args))

let fn_setcar args _ =
  let first = car args in
  let second = car (cdr args) in
    (match first with
         Cons (c) ->
           c.car <- second
       | _ -> invalid_arg "First argument to setcar must be a Cons") ;
    tee

let fn_setcdr args _ =
  let first = car args in
  let second = car (cdr args) in
    (match first with
        Cons (c) ->
          c.cdr <- second
       | _ -> invalid_arg "First argument to setcdr must be a Cons") ;
    tee

let fn_equal args _ =
  let first = car args in
  let second = car (cdr args) in
    if (name first) = (name second) then
      tee
    else
      nil
        
let fn_atom args _ =
  match (car args) with
      Atom (_) -> tee
    | _ -> nil

let rec fn_lambda args env =
  let lambda = (car args) in
  let rest = (cdr args) in
    match lambda with
        Lambda (largs, lsexp) ->           
          let lst = interleave largs rest in
          let sexp = replace_atom lsexp lst in            
            eval sexp env
      | _ -> invalid_arg "Argument to lambda must be a Lambda"          
and eval sexp env =
  match sexp with
      Null -> nil
    | Cons (_) ->
        (match (car sexp) with
             Atom ("LAMBDA") ->
               let largs = car (cdr sexp) in
               let lsexp = car (cdr (cdr sexp)) in
                 Lambda (largs, lsexp)                    
           | _ ->
               let acc = cons (eval (car sexp) env) Null in
               let rec loop s =
                 match s with
                     Cons (_) ->
                       append acc (eval (car s) env) ;
                       loop (cdr s)
                   | _ -> ()
               in
                 loop (cdr sexp) ;
                 eval_fn acc env)
    | _ ->
        let v = Symtab.lookup env (name sexp) in
          match v with
              Null -> sexp
            | _ -> v                          
                
and eval_fn sexp env =
  let symbol = car sexp in
  let args = cdr sexp in
    match symbol with
        Lambda (_) ->
          fn_lambda sexp env
      | Func (fn) ->
          (fn args env)
      | _ -> sexp  

          
let fn_cond args env =
  let rec loop a =
    match a with
        Cons (_) ->
          begin
            let lst = car a in
            let pred = (if (car lst) != nil then
                          eval (car lst) env
                        else
                          nil)
            in
            let ret = car (cdr lst) in
              if pred != nil then
                eval ret env
              else
                loop (cdr a)
          end
      | _ -> nil
  in
    loop args

let fn_label args env =
  Symtab.add env (name (car args))
    (car (cdr args)) ;
  tee
      
let rec lisp_print sexp =
  match sexp with
      Null -> ()
    | Cons (_) ->
        begin
          Printf.printf "(" ;
          lisp_print (car sexp) ;
          let rec loop s =
            match s with
                Cons (_) ->
                  Printf.printf " " ;
                  lisp_print (car s) ;
                  loop (cdr s)
              | _ -> ()
          in
            loop (cdr sexp) ;
            Printf.printf ")" ;
        end
    | Atom (n) ->
        Printf.printf "%s" n
    | Lambda (largs, lsexp) ->
        Printf.printf "#" ;
        lisp_print largs ;
        lisp_print lsexp
    | _ ->
        Printf.printf "Error."                                
