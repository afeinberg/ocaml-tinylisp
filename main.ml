open Builtins
open Environment
open Sexp

let lisp_read inp =
  let lexbuf = Lexing.from_channel inp in
    Parser.main Lexer.token lexbuf

let make_cell n fn =
  (cons (Atom n) (cons (Func fn) Null))
    
let init_env () =
  let env = cons (make_cell "QUOTE" fn_quote) Null in
  let cells =
    [ make_cell "CAR" fn_car ;
      make_cell "CDR" fn_cdr ;
      make_cell "CONS" fn_cons ;
      make_cell "EQUAL" fn_equal ;
      make_cell "ATOM" fn_atom ;
      make_cell "COND" fn_cond ;
      make_cell "LAMBDA" fn_lambda ;
      make_cell "LABEL" fn_label ]
  in
    List.iter (append env) cells ;
    env
      
let _ =
  let env = init_env () in
  let chin = stdin 
  in
    while true do
      (try
         Printf.printf "> " ;
         lisp_print (eval (lisp_read chin) env) 
       with
           Parsing.Parse_error -> Printf.printf "Parser error" 
         | Lexer.Eof -> exit 0);
      Printf.printf "\n"            
    done
      
