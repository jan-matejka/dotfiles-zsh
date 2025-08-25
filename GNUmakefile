.DEFAULT_GOAL := build

zshrc   ?= $(HOME)/.zshrc
zshdir   = $(HOME)/.zsh
funcdir  = $(zshdir)/functions

.PHONY: build
build:

.PHONY: install
install:

	install -m600 .zshrc $(zshrc)
	install -m700 -d $(HOME)/.local/share/zsh
	install -m700 -d $(funcdir)
	install -m600 functions/prompt_yac_setup $(funcdir)/prompt_yac_setup
