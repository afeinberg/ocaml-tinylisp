open Sexp

let append lst o =
  let rec loop ptr =
    match (cdr ptr) with
        Cons (_) -> loop (cdr ptr)
      | _ ->
          match ptr with
              Cons (c) ->
                c.cdr <- cons o Null
            | _ -> invalid_arg "Append needs a cdr"
  in
    loop lst
      
let rec replace_atom sexp rep =
  match sexp with
      Cons (_) ->
        begin 
          let lst = (cons (replace_atom (car sexp) rep) Null) in
          let rec loop s =
            match s with
                Cons(_) ->
                  begin 
                    append lst (replace_atom (car s) rep) ;
                    loop (cdr s)
                  end
              | _ -> ()
          in
            loop (cdr sexp);
            lst
        end
    | _ ->
        let rec loop tmp =
          match tmp with
              Cons (_) ->
                begin
                  let item = (car tmp) in
                  let atom = (car item) in
                  let replacement = (car (cdr item)) in
                    if (name atom) = (name sexp) then
                      replacement
                    else
                      loop (cdr tmp)
                end
            | _ -> sexp
        in
          loop rep      
      
let interleave c1 c2 =
  let lst = cons (cons (car c1) (cons (car c2) Null)) Null in
  let c1' = cdr c1 in
  let c2' = cdr c2 in

  let rec loop a b =
    match a with
        Cons (_) ->
          begin
            append lst (cons (car a) (cons (car b) Null)) ;
            loop (cdr a) (cdr b)
          end
      | _ -> ()

  in
    loop c1' c2' ;
    lst        
      
      
