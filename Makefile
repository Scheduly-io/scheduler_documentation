

all: help
##	help:		prints this help
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<
	@echo ""


##	local:		run local server with the webpage
.PHONY : local
local:
	bundle exec middleman server

##	build:		compiles the files in target folder
.PHONY : build
build:
	bundle exec middleman build
