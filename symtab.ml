type t = (string, Sexp.t) Hashtbl.t
    
let create n = Hashtbl.create n

let add tab name sym =
  Hashtbl.add tab name sym
    
let lookup tab name =
  try
    Hashtbl.find tab name
  with
      Not_found -> Sexp.Null

        
