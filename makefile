
info:
	@echo This is a make file which produces a factorio mod file out of the current state of your local git-repo.'\n\t'run \"make all\" to generate a zip file'\n\t'Please make sure, you have all files needed.'\n\t'If youre unsure, just run \"make check\" to see whats missing.

ignore:
	@echo "the .makeignore file is a simple list of files, which should not be included in the generated zip file. Each line holds one file- or directory-name. Wildcards are supported. see \"man rsync\" for more information on exclusion lists.\n"
	@test -s .makeignore || { echo "There ist no .makeignore file present. Creating a basic one..."; echo ".makeignore\nmakefile" > .makeignore; echo "done.\n\n";}
	@echo "\n\n"

all: check zip

check:
#	ifeq (, $(shell test -f ./info.json))
#		$(error "info.json file is missing! Exiting...")
#	endif
#	ifeq (, $(shell test -f ./.makeignore)
#		$(error ".makeignore file is missing! If you need more information about that file, run \"make ignore\".\nExiting...")
#	endif
#	ifeq (, $(shell which jq))
#		$(error "jq is missing. Please install it using yuor normal package manager on linux.\nExiting...")
#	endif

zip:
	$(eval NAME := $(shell jq -r '.name' info.json || { echo "jq is missing. Please install jq.\nExiting..."; exit 1; }))
	$(eval VERSION := $(shell jq -r '.version' info.json))
	@echo $(NAME)_$(VERSION)
	@echo make temporary directory
	@mkdir $(NAME)_$(VERSION)
	@echo add corresponding files to directory
	@rsync -a --exclude-from=.makeignore --exclude=$(NAME)_$(VERSION) ./ $(NAME)_$(VERSION)/
	@echo zipping directory to file
	@zip -9 -rq $(NAME)_$(VERSION).zip $(NAME)_$(VERSION)
	@echo removing temporary directory
	@rm -r $(NAME)_$(VERSION)/
	@echo "done.\n\n"
