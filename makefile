NAME := $(shell jq -r '.name' info.json)
VERSION := $(shell jq -r '.version' info.json)
zip:
	@echo $(VERSION)
	@mkdir $(NAME)_$(VERSION)
	@rsync -a --exclude-from=.makeignore --exclude=$(NAME)_$(VERSION) ./ $(NAME)_$(VERSION)/
	@zip -9 -rq $(NAME)_$(VERSION).zip $(NAME)_$(VERSION)
	@rm -r $(NAME)_$(VERSION)/
