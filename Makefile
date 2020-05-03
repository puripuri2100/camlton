PREFIX=/usr/local
TARGET=camlton
BINDIR=$(PREFIX)/bin
BUILD=_build


.PHONY: build install uninstall clean example test

build: src
	dune build src/main.exe
	cp ${BUILD}/default/src/main.exe ./${TARGET}

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
	./camlton -c test/3.json

clean:
	@rm -rf *.cmi *.cmx *.cmo *.o *.out ${BUILD} ${TARGET}