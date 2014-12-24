ifneq ($(wildcard ~/.zshrc),)
	RC = ~/.zshrc
else
	RC = ~/.bashrc
endif

ifneq ($(findstring GNU,$(shell sed --version 2>&1)),)
	SEDI = sed -i
else
	SEDI = sed -i ""
endif

aliases: git docker
	$(SEDI) \
	-e '$$a\'$$'\n''source ~/.git.sh' \
	-e '$$a\'$$'\n''source ~/.docker.sh' \
	-e '/.git.sh/d' \
	-e '/.docker.sh/d' \
	$(RC)
	@echo "Type . $(RC) to apply new aliases!"

git:
	cp git.sh ~/.git.sh

docker:
	cp docker.sh ~/.docker.sh
