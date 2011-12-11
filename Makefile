OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLDEP=ocamldep
INCLUDES=
OCAMLFLAGS=$(INCLUDES) -g
OCAMLOPTFLAGS=$(INCLUDES)

MAIN_OBJS=sexp.cmo parser.cmo lexer.cmo environment.cmo builtins.cmo main.cmo

tiny_lisp: .depend $(MAIN_OBJS)
	$(OCAMLC) -o tiny_lisp $(OCAMLFLAGS) $(MAIN_OBJS)

.SUFFIXES: .ml .mli .cmo .cmi .cmx .mll .mly

.mll.ml:
	ocamllex $<
.mly.ml:
	ocamlyacc $<
.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.ml.cmx:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -c $<

clean:
	rm -f tiny_lisp
	rm -f *~
	rm -f *.cm[iox]
	rm -f parser.ml parser.mli
	rm -f lexer.ml

parser.cmo : parser.cmi
parser.mli : parser.mly
parser.ml : parser.mly


.depend:
	$(OCAMLDEP) $(INCLUDES) *.mli *.ml *.mly *.mll > .depend

include .depend