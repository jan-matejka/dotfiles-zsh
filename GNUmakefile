.DEFAULT_GOAL := build

conf=$(wildcard config.mk)
ifneq ($(conf),)
include config.mk
endif

ZSHRC?=$(HOME)/.zshrc

.PHONY: build
build:

.PHONY: install
install:

	install -m644 .zshrc $(ZSHRC)
	install -m700 -d $(HOME)/.local/share/zsh
