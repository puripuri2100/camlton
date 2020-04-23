PREFIX=/usr/local
TARGET=camlton
BINDIR=$(PREFIX)/bin
BUILD=__build


.PHONY: build install uninstall clean example test

build: src
	-mkdir ${BUILD}
	cp src/*.ml src/*.mli ${BUILD}
	cd ${BUILD} && ocamlfind ocamlopt -o ${TARGET} -linkpkg -package "yojson" error.mli error.ml readJson.mli readJson.ml optionState.mli optionState.ml camlton.mli camlton.ml main.ml
	cp ${BUILD}/${TARGET} ./

install: ${TARGET}
	mkdir -p $(BINDIR)
	install $(TARGET) $(BINDIR)

uninstall:
	rm -rf $(BINDIR)/$(TARGET)


example:
	camlton -c example/example1.json

test:
	./camlton -c test/1.json
	./camlton -c test/2.json

clean:
	@rm -rf *.cmi *.cmx *.cmo *.o *.out ${BUILD} ${TARGET}