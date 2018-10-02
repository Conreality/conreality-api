PACKAGE := conreality-api
VERSION := $(shell cat VERSION)

PANDOC  ?= pandoc
PROTOC  ?= protoc
PYTHON2 ?= python
PYTHON3 ?= python3

TARGETS := c cpp csharp dart elixir go java js objc ocaml php python2 python3 ruby swift

SOURCES := \
  conreality_common.proto \
  conreality_nexus.proto  \
  conreality_master.proto \
  conreality_slave.proto

%.html: %.rst
	$(PANDOC) -o $@ -t html5 -s $<

all: build

build: $(TARGETS)

check:
	@echo "not implemented"; exit 2 # TODO

dist:
	@echo "not implemented"; exit 2 # TODO

install:
	@echo "not implemented"; exit 2 # TODO

uninstall:
	@echo "not implemented"; exit 2 # TODO

clean:
	@rm -Rf *~ $(TARGETS)

distclean: clean

mostlyclean: clean

.PHONY: check dist install clean distclean mostlyclean
.SECONDARY:
.SUFFIXES:

# See: https://github.com/protobuf-c/protobuf-c
c: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --c_out=$@ $^

# See: https://github.com/grpc/grpc/tree/master/src/cpp
cpp: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --cpp_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` --grpc_out=$@ $^

# See: https://github.com/grpc/grpc/tree/master/src/csharp
csharp: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --csharp_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_csharp_plugin` --grpc_out=$@ $^

# See: https://github.com/dart-lang/protobuf
# See: https://github.com/grpc/grpc-dart
dart: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --plugin=$(HOME)/.pub-cache/bin/protoc-gen-dart --dart_out=grpc:$@ $^

# See: https://github.com/tony612/protobuf-elixir
elixir: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --plugin=$(HOME)/.mix/escripts/protoc-gen-elixir --elixir_out=plugins=grpc:$@ $^

# See: https://github.com/golang/protobuf
# See: https://github.com/grpc/grpc-go
go: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --plugin=$(GOPATH)/bin/protoc-gen-go --go_out=plugins=grpc:$@ $^

# See: https://github.com/grpc/grpc-java
java: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --java_out=$@ $^

# See: https://github.com/grpc/grpc-node
js: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --js_out=$@ $^
	#$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_node_plugin` --grpc_out=$@ $^

# See: https://github.com/grpc/grpc/tree/master/src/objective-c
objc: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --objc_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_objective_c_plugin` --grpc_out=$@ $^

# See: https://github.com/mransan/ocaml-protoc
ocaml: $(SOURCES)
	mkdir -p $@
	ocaml-protoc -binary -ml_out $@ conreality_common.proto

# See: https://github.com/grpc/grpc/tree/master/src/php
php: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --php_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_php_plugin` --grpc_out=$@ $^

python: python2

# See: https://github.com/grpc/grpc/tree/master/src/python
python2: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --python_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_python_plugin` --grpc_out=$@ $^
	#$(PYTHON2) -m grpc_tools.protoc -I. --python_out=$@ --grpc_python_out=$@ $^

# See: https://github.com/grpc/grpc/tree/master/src/python
python3: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --python_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_python_plugin` --grpc_out=$@ $^
	#$(PYTHON3) -m grpc_tools.protoc -I. --python_out=$@ --grpc_python_out=$@ $^

# See: https://github.com/grpc/grpc/tree/master/src/ruby
ruby: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --ruby_out=$@ $^
	$(PROTOC) -I. --plugin=protoc-gen-grpc=`which grpc_ruby_plugin` --grpc_out=$@ $^

# See: https://github.com/apple/swift-protobuf
# See: https://github.com/grpc/grpc-swift
swift: $(SOURCES)
	mkdir -p $@
	$(PROTOC) -I. --swift_out=$@ $^

.PHONY: $(TARGETS)
