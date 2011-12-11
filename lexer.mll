{
  open Parser
  exception Eof
}

rule token = parse
    [' ' '\t' '\n'] { token lexbuf }
  | '(' { LPAREN }
  | ')' { RPAREN }
  | ';' [^ '\n']* { token lexbuf } (* comments *)
  | ['A'-'z' '0'-'9' '*']+ { NAME(Lexing.lexeme lexbuf) }
  | eof { raise Eof }

      
