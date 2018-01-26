.DEFAULT_GOAL := build

zshrc   ?= $(HOME)/.zshrc
zshdir   = $(HOME)/.zsh
funcdir  = $(zshdir)/functions

.PHONY: build
build:

.PHONY: install
install:

	install -m644 .zshrc $(zshrc)
	install -m700 -d $(HOME)/.local/share/zsh
	mkdir -p $(funcdir)
	install -m644 functions/prompt_yac_setup $(funcdir)/prompt_yac_setup
