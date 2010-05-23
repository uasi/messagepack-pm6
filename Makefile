PERL          = perl
PARROT_CONFIG = parrot_config
BIN_DIR       = `$(PARROT_CONFIG) bindir`
LIB_DIR       = `$(PARROT_CONFIG) libdir`
TOOLS_LIB_DIR = $(LIB_DIR)`$(PARROT_CONFIG) versiondir`/tools/lib

.PHONY: all test

all:

test:
	$(PERL) -I$(TOOLS_LIB_DIR) t/harness --bindir=$(BIN_DIR)

# Local variables:
#   mode: makefile
# End:
# vim: ft=make:

