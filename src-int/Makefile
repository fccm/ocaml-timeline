OCAML = ocaml
OCAMLC = ocamlc -g
OCAMLOPT = ocamlopt -g
OCAMLDOC = ocamldoc
OCAMLFIND = ocamlfind

OCAML_DIR = $(shell $(OCAMLC) -where)
DOC_DIR = doc
MKDIR = mkdir -p

.PHONY: all opt
all: iTimed.cma  ipTimed.cma
opt: iTimed.cmxa ipTimed.cmxa

.SECONDARY:

%.cmi: %.mli
	$(OCAMLC) -c -o $@ $<

%.cmo: %.ml %.cmi
	$(OCAMLC) -c $<
%.cmo: %.ml
	$(OCAMLC) -c $<

%.cmx: %.ml %.cmi
	$(OCAMLOPT) -c $<
%.cmx: %.ml
	$(OCAMLOPT) -c $<

%.cma: %.cmi %.cmo
	$(OCAMLC) -a -o $@ $(lastword $^)

%.cmxa: %.cmi %.cmx
	$(OCAMLOPT) -a -o $@ $(lastword $^)

%.cmxs: %.cmxa
	$(OCAMLOPT) -shared -linkall -o $@ $<

.PHONY: findinstall
findinstall: META
	$(OCAMLFIND) install itimed META *.cm[iax] *.cmx[as] *.mli *.a

.PHONY: doc
doc:
	$(MKDIR) $(DOC_DIR)
	$(OCAMLDOC) -d $(DOC_DIR) -html iTimed.mli

.PHONY: cleandoc
cleandoc:
	$(RM) -r $(DOC_DIR)

.PHONY: clean
clean:
	$(RM) *.[oa] *.cm[ioxa] *.cmx[as] *.opt *.exe *.byte

