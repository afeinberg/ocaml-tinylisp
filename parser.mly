%token <string> NAME
%token LPAREN RPAREN EOF
%start main
%type <Sexp.t> main

%%

main:
  sexp { $1 }
  ;

sexp:
  list { $1 }
| atom { $1 }
;

list:
  LPAREN RPAREN { Sexp.Null }
| LPAREN inside_list RPAREN { $2 }

inside_list:
  | sexp { Sexp.cons $1 Sexp.Null } 
  | sexp inside_list { Sexp.cons $1 $2 }
;

atom: NAME { Sexp.Atom $1 }
;
  
     
