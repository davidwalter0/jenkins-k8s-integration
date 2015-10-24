.PHONY: deps
SHELL=/bin/bash
MAKEFILE_PATH := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))
DIR=$(MAKEFILE_PATH)
TESTDIR=$(DIR)/test
# PACKAGE=helper packages?
# PACKAGE_DEPS:=$(PACKAGE)/.dep

define GO_MAIN_FILTER :=
for file in $(wildcard *.go); do
  if grep -q '^func *main *(' $${file}; then
     echo $${file};
  fi;
done;
endef

define GO_HELPERS_FILTER :=
for file in $(wildcard *.go); do
  if ! grep -q '^func *main *(' $${file}; then
     echo $${file};
  fi;
done;
endef

GO_HELPERS:=$(shell ${GO_HELPERS_FILTER})
GO_MAINS:=$(shell ${GO_MAIN_FILTER})
TARGETS:=$(patsubst %.go,bin/%,${GO_MAINS})

all:
	@echo helpers ${GO_HELPERS}
	@echo mains ${GO_MAINS}
	@printf "\n--------------------------------\n"
	@printf "Running in abs directory\n    $(MAKEFILE_PATH)\n"
	@printf "The subdirectory is $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))\n"
	@printf "\n--------------------------------\n"
	@printf "make TARGETS init to initialize godeps, get, save, test and build\n"

build: $(TARGETS) 

deps: $(PACKAGE_DEPS) .dep 

.dep: $(TARGETS)
	touch .dep

# $(PACKAGE_DEPS):
# 	(								\
# 		cd $(PACKAGE);						\
# 		GO15VENDOREXPERIMENT=1 GOPATH=${GOPATH}			\
# 		   $(GOPATH)/bin/godep go build -a -ldflags '-s';	\
# 		GO15VENDOREXPERIMENT=1 GOPATH=${GOPATH}			\
# 		   $(GOPATH)/bin/godep go install -ldflags "-s"		\
# 	)								\
# 	touch $(PACKAGE)/.dep

%: bin/% $(GO_HELPERS)

bin/%: %.go $(GO_HELPERS) $(PACKAGE_DEPS)
	@echo "Building via % rule for $@ from $<"
	@mkdir -p bin
	GO15VENDOREXPERIMENT=1 CGO_ENABLED=0 GOPATH=${GOPATH} \
		$(GOPATH)/bin/godep go build -a -ldflags '-s' -o $@ $< $(GO_HELPERS)

init: get save make-def

get: 
	GO15VENDOREXPERIMENT=1 GOPATH=${GOPATH} $(GOPATH)/bin/godep get $(libdep)
save:
	GO15VENDOREXPERIMENT=1 GOPATH=${GOPATH} $(GOPATH)/bin/godep save
test: 
	GO15VENDOREXPERIMENT=1 GOPATH=${GOPATH} $(GOPATH)/bin/godep go test

make-def: 
	# (						\
	# cp header.go.tmpl api-def.go;			\
	# pushd api &>/dev/null;			\
	# echo;						\
	# for name in $(DIR)/api/*.json; do		\
	# 	printf "// ";				\
	# 	printf "%c" -{1..72};			\
	# 	printf "\n// %s\n//" $${name##*/};	\
	# 	printf "%c" -{1..72};			\
	# 	echo;					\
	# 	jsonutil -c -f $${name##*/};		\
	# 	echo;					\
	# done;						\
	# popd &>/dev/null				\
	# ) >> api-def.go

clean:
	@echo cleaning up temporary files
	@echo rm -f $(TARGETS)
	@rm -f $(TARGETS) .dep $(PACKAGE_DEPS)

