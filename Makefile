# make local     collect host.c, scr_*.c and the headers they use (needs ROOT)
# make           build from the files in this folder only (remote)
# make clean     remove build output
# make tarball   make local, then pack the files for test -> scrtest.tar.gz
# make distclean also remove collected files and tarball (local)

ROOT  ?= ../../idf-waveshare
SDIR  := $(ROOT)/src
TDIR  := $(ROOT)/tests/scrtest
SCDIR := $(ROOT)/sd/scripts
HLST  := .headers
TAR   := scrtest.tar.gz
TARX  := $(wildcard *.sh README.txt)

# --- scripts to ship: scripts/NAME.s + scripts/data/NAME.txt (if present)
SCRIPTS := boastbc
SCRS := $(SCRIPTS:%=scripts/%.s)
SDAT := $(patsubst $(SCDIR)/%,scripts/%,$(wildcard $(SCRIPTS:%=$(SCDIR)/data/%.txt)))

# --- build (uses only files in this folder)
SRC  := $(wildcard *.c)
OBJ  := $(SRC:.c=.o)
DEP  := $(OBJ:.o=.d)

CFLAGS := -std=gnu11 -I. -MMD -MP
LIBS   := -lm
EXE    := scrtest

.PHONY: all local tarball clean distclean help
.SECONDARY:

help:
	@echo "   make all       build from the files in this folder only (remote)"
	@echo "   make clean     remove build output"
	@echo ""
	@echo "   make local     collect host.c, scr_*.c and the headers they use (needs ROOT)"
	@echo "   make distclean also remove collected files and tarball (local)"
	@echo "   make tarball   make local, then pack the files for test -> scrtest.tar.gz"

all: $(EXE)
	$(if $(wildcard *.sh),@chmod +x $(wildcard *.sh))
	@echo "now use   ./boast.sh   to run the game"

$(EXE): $(OBJ)
	$(if $(SRC),,$(error no .c files here - run 'make local' first))
	gcc $^ $(LIBS) -o $@

%.o: %.c
	gcc $(CFLAGS) -c $< -o $@

# --- collect (local machine only)
CSRC := host.c $(notdir $(wildcard $(SDIR)/scr_*.c))
OSRC := $(TDIR)/host.c $(wildcard $(SDIR)/scr_*.c)

local: $(CSRC) $(SCRS) $(SDAT)
	gcc -std=gnu11 -I$(SDIR) -MM $(OSRC) | tr ' \\' '\n\n' \
	  | grep '^$(SDIR)/.*\.h$$' | sort -u > $(HLST)
	xargs -r cp -t . < $(HLST)

host.c: $(TDIR)/host.c
	cp $< $@

%.c: $(SDIR)/%.c
	cp $< $@

scripts/%.s: $(SCDIR)/%.s
	mkdir -p $(@D)
	cp $< $@

scripts/data/%.txt: $(SCDIR)/data/%.txt
	mkdir -p $(@D)
	cp $< $@

tarball: local
	tar czf $(TAR) Makefile $(CSRC) $(SCRS) $(SDAT) $(TARX) $$(xargs -r -n1 basename < $(HLST))

# --- tidy
clean:
	rm -f $(EXE) $(OBJ) $(DEP)

distclean: clean
	[ -f $(HLST) ] && xargs -r -n1 basename < $(HLST) | xargs -r rm -f || true
	rm -f $(CSRC) $(SCRS) $(SDAT) $(HLST) $(TAR)
	rmdir -p scripts/data 2>/dev/null || true

-include $(DEP)
