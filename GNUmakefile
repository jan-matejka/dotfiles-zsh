.DEFAULT_GOAL := build

USER ?= $(shell whoami)
zshrc   ?= $(HOME)/.zshrc
zshdir   = $(HOME)/.zsh
funcdir  = $(zshdir)/functions

.PHONY: build
build:

.PHONY: install
install:

	install -m600 --owner=$(USER) .zshrc $(zshrc)
	install -m700 --owner=$(USER) -d $(HOME)
	install -m700 --owner=$(USER) -d $(HOME)/.local
	install -m700 --owner=$(USER) -d $(HOME)/.local/share
	install -m700 --owner=$(USER) -d $(HOME)/.local/share/zsh
	install -m700 --owner=$(USER) -d $(zshdir)
	install -m700 --owner=$(USER) -d $(funcdir)
	install -m600 --owner=$(USER) functions/prompt_yac_setup $(funcdir)/prompt_yac_setup

.PHONY: diff
diff:

	diff -burN $(HOME)/.zshrc .zshrc || [ $$? -eq 1 ]
	diff -burN $(funcdir) functions/ || [ $$? -eq 1 ]
