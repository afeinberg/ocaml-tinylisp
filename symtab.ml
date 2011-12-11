type t = (string, Sexp.t) Hashtbl.t
    
let create n = Hashtbl.create n

let add tab name sym =
  Hashtbl.add tab (String.uppercase name) sym
    
let lookup tab name =
  try
    Hashtbl.find tab (String.uppercase name)
  with
      Not_found -> Sexp.Null

        
