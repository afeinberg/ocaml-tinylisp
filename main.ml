open Builtins
open Environment
open Sexp

let lisp_read inp =
  let lexbuf = Lexing.from_channel inp in
    Parser.main Lexer.token lexbuf
    
let init_env () =
  let env = Symtab.create 32 in
  let syms = [ "QUOTE", fn_quote ;
               "CAR", fn_car ;
               "CDR", fn_cdr ;
               "CONS", fn_cons ;
               "EQUAL", fn_equal ;
               "ATOM", fn_atom ;
               "COND", fn_cond ;
               "LAMBDA", fn_lambda ;
               "LABEL", fn_label ;
               "SETCAR", fn_setcar ;
               "SETCDR", fn_setcdr ]
  in
    List.iter (fun (name, sym) ->
                 Symtab.add env name (Func sym)) syms;
    env
      
let _ =
  let env = init_env () in
  let chin = stdin 
  in
    while true do
      try
        print_string "> " ;
        flush stdout ;
        let sexp_eval = eval (lisp_read chin) env in
          lisp_print sexp_eval ;
          print_newline () ;
      with
          Parsing.Parse_error -> print_endline "Parse error"
        | Lexer.Eof -> exit 0
    done
      
