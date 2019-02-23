# Makefile
# Copyright © 2019 Synthelytics LLC. All rights reserved.
#
# ==============================================================================
# PROGRAM: Makefile
# AUTHORS: Robert L. Jones
# COMPANY: Synthelytics LLC
# VERSION: 1.0
# CREATED: 04FEB2019
# REVISED: 18FEB2019
# ==============================================================================

# .ONESHELL:
# .EXPORT_ALL_VARIABLES:

# ==============================================================================
# Variables
# ==============================================================================

# Settings

SHELL = bash

# Special Characters

EMPTY =
SPACE = $(EMPTY) $(EMPTY)

# Accounts

USER = $(shell whoami)

GITHUB_USER = $(USER)

# Commands

MKDIR = mkdir -p

# Debugging & Error Capture

FAILURE = (printf "$(FAILED)" && echo && cat $(LOG) && echo)
SUCCESS = printf "$(DONE)"
RESULT = ([ $$? -eq 0 ] && $(SUCCESS)) || $(FAILURE)

VARIABLES_TO_SHOW = GITHUB GITHUB_USER MAKEFILE MAKEFILE_DIR ORIGIN PREFIX PROJECT PWD RESOURCES_DIRS SOURCES_DIRS USER

# Directories

MAKEFILE_DIR = $(dir $(realpath $(MAKEFILE)))
PREFIX = $(PWD)
SUBDIR = $(shell basename $(@D))

PROJECT = $(shell basename $(PREFIX))

RESOURCES = Data Fonts Localization Media UserInterfaces
RESOURCES_DIRS = $(addprefix $(PROJECT)/Resources/,$(addsuffix /.,$(RESOURCES)))

BIN_DIR = bin/.
LOG_DIR = logs/.
SETUP_DIRS = $(BIN_DIR) $(LOG_DIR)

SOURCES = Controllers Extensions Models Protocols ViewModels Views
SOURCES_DIRS = $(addprefix $(PROJECT)/Sources/,$(addsuffix /.,$(SOURCES)))

DIRS = $(SETUP_DIRS) $(RESOURCES_DIRS) $(SOURCES_DIRS)

# Files

FILE = $(basename $@)
MAKEFILE = $(lastword $(MAKEFILE_LIST))

# Used to create special empty ("marker") files in order to:
# 1. Automaticcally create directory trees if they don't already exist;
# 2. Avoid directory tree rebuilds as their directory timestamps changed.
###DUMMY_FILES = $(addsuffix /.dummy,$(DIRS)) # RLJ: Commented out. 23FEB2019

CARTHAGE_FILES = Cartfile Cartfile.private
COCOAPODS_FILES = Framework.podspec

DOCS1 = CHANGELOG ISSUE_TEMPLATE README REFERENCES SUPPORT
DOCS2 = $(addprefix .github/,CODE_OF_CONDUCT CONTRIBUTING) 
DOCS3 = $(addprefix .github/ISSUE_TEMPLATE/,bug_report custom feature_request)

#MD_FILES = CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md ISSUE_TEMPLATE.md README.md REFERENCES.md
MD_FILES = $(addsuffix .md,$(DOCS1) $(DOCS2) $(DOCS3))

#LOG = $(shell mktemp /tmp/log.XXXXXXXXXX)
#LOG = `mktemp /tmp/log.XXXXXXXXXX`
#LOG = $(shell mktemp -t /tmp make.log.XXXXXXXXXX)
#LOG = $(shell mktemp)
#LOG = /tmp/make.$$$$.log
LOG = make.log

# URLs

GITHUB = https://raw.githubusercontent.com/$(GITHUB_USER)/makefile-xcode/master/templates
ORIGIN = https://github.com/$(GITHUB_USER)/$(PROJECT).git

# STDOUT format settings

RESET = \033[0m
BOLD = \033[1m
DIM = \033[2m

FG_CYAN = \033[0;36m
FG_GREEN = \033[0;32m
FG_RED = \033[0;31m
FG_YELLOW = \033[1;33m

# Help strings

PREFIX_ARG = $(FG_CYAN)<prefix>$(RESET)
TARGET_ARG = $(FG_CYAN)<target>$(RESET)
USER_ARG = $(FG_CYAN)<user>$(RESET)

MAKE = make $(TARGET_ARG) [PREFIX=$(PREFIX_ARG)] [USER=$(USER_ARG)]

define HELP1

Usage:
  $(MAKE)

Targets:

endef
export HELP1

HELP2 = $(FG_CYAN)%-17s$(RESET) %s

# Path strings

DIR_VAR = $(FG_CYAN)$(@D)$(RESET)
FILE_VAR = $(FG_CYAN)$(FILE)$(RESET)
SUBDIR_VAR = $(FG_CYAN)$(SUBDIR)$(RESET)

TARGET_VAR = $(FG_CYAN)$@$(RESET)

# Result strings

DONE = $(FG_GREEN)done$(RESET).\n
FAILED = $(FG_RED)failed$(RESET).\n
IGNORE = $(FG_YELLOW)ignore$(RESET).\n

# ==============================================================================
# Phony Targets
#
# A phony target is a convenient name for a set of commands to be executed when
# an explicit request is made.  Its commands won't run if a file of the same
# name exists.  Two reasons to use a phony target are:
#
# 1. To avoid a conflict with a file of the same name;
# 2. To improve performance.
# ==============================================================================

# Main phony targets

.PHONY: all build clean docs setup test

all: help

clean: clean-git clean-carthage clean-cocoapods clean-md clean-dirs ## Removes files and directories.

docs: | $(LOG) ## Makes API documentation.
	@printf "Generating API documentation..."
	@jazzy \
		--min-acl internal \
		--no-hide-documentation-coverage \
		--theme fullwidth \
		--output ./docs \
        --documentation=./*.md \
		>$(LOG) 2>&1; \
	$(RESULT)
	@rm -rf ./build

help: ## Shows usage documentation.
	@printf "$$HELP1"
	@egrep '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | \
	sed -e 's/:.* ##/: ##/' | sort -d | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  $(HELP2)\n", $$1, $$2}'
	@echo ""

init: init-dirs init-md init-carthage init-cocoapods init-git ## Completes all initial repo setup activities.

test: vars-some ## Completes all test activities.
	tree $(PREFIX)

# Prerequisite phony targets for cleaning activities

.PHONY: clean-carthage clean-cocoapods clean-dirs clean-git clean-md

clean-carthage: | $(LOG) ## Completes all Carthage cleanup activities.
	@printf "Removing Carthage setup..."
	@rm -rf $(CARTHAGE_FILES) >$(LOG) 2>&1; \
	$(RESULT)

clean-cocoapods: | $(LOG) ## Completes all CocoaPods cleanup activities.
	@printf "Removing CocoaPods setup..."
	@rm -rf $(COCOAPODS_FILES) >$(LOG) 2>&1; \
	$(RESULT)

clean-dirs: | $(LOG) ## Completes all directory cleanup activities.
	@printf "Removing directories setup..."
	@rm -rf $(PROJECT) $(dir $(SETUP_DIRS)) >$(LOG) 2>&1; \
	$(RESULT)

clean-git: | $(LOG) ## Completes all git cleanup activities.
	@printf "Removing git setup..."
	@rm -rf .git .gitignore >$(LOG) 2>&1; \
	$(RESULT)

clean-md: | $(LOG) ## Completes all Markdown cleanup activities.
	@printf "Removing Markdown setup..."
	@rm -rf $(MD_FILES) >$(LOG) 2>&1; \
	$(RESULT)

# Prerequisite phony targets for setup activities

.PHONY: init-carthage init-cocoapods init-dirs init-git init-md 

init-carthage: $(CARTHAGE_FILES) ## Completes all initial Carthage setup activities.

init-cocoapods: $(COCOAPODS_FILES) ## Completes all initial CocoaPods setup activities.

#dirs: ## Completes all directory setup activities.
#	@printf "Setting up directory tree rooted in ./$(PROJECT)..."
#	@if [ ! -d "$(PROJECT)" ]; then \
#		mkdir -p $(@D) ./$(PROJECT)/{$(SOURCES),$(RESOURCES)} \
#		&& printf "$(DONE)" \
#		|| printf "$(FAILED)" \
#	else \
#		printf "$(IGNORE)"; \
#	fi
#dirs: $(DUMMY_FILES) ## Completes all directory setup activities.
init-dirs: $(DIRS) ## Completes all initial directory setup activities.

init-git:  .gitignore .git | $(LOG) ## Completes all initial git setup activities.
	@printf "Committing the initial project to the master branch..."
	@git checkout -b master >$(LOG) 2>&1; \
	git add . >>$(LOG) 2>&1; \
	git commit -m "Initial project setup" >>$(LOG) 2>&1; \
	$(RESULT)
	@printf "Syncing the initial project with the origin..."
	@git remote add origin $(ORIGIN) >$(LOG) 2>&1; \
	git push -u origin master >$(LOG) 2>&1; \
	$(RESULT)

init-md: $(MD_FILES) ## Completes all initial Markdown file setup activites.

# Prerequisite phony targets for test activities

.PHONY: test-log  test-vars-all test-vars-some

test-log: ## Shows the most recently generated log for a specified release.
	@echo
	#@set -e; \
	#LOG==$$(ls -l $(LOGS_DIR)/* | head -1); \
	#printf "Showing the most recent log: $(LOG_FILE)\n"; \
	#echo; \
	#cat $$LOG
	printf "Showing the most recent log: $(LOG_FILE)\n"
	@echo
	@cat $(LOG_FILE)

test-vars-all: ## Shows all Makefile variables (i.e., built-in and custom).
	@echo
	$(foreach v, $(.VARIABLES), $(info $(v) = $($(v))))

test-vars-some: ## Shows only a few custom Makefile variables.
	@echo
	$(foreach v, $(VARIABLES_TO_SHOW), $(info $(v) = $($(v))))

# ==============================================================================
# Directory Targets
# ==============================================================================

%/.: | $(LOG) ## Makes a directory tree.
	@printf "Making directory tree $(DIR_VAR)..."
	@mkdir -p $(@D) >$(LOG) 2>&1; \
	$(RESULT)

# ==============================================================================
# File Targets
# ==============================================================================

# https://stackoverflow.com/questions/32672222/how-to-download-a-file-only-if-more-recently-changed-in-makefile
%.download: | $(LOG) ## Downloads a file.
#	$(eval FILE = $(basename $@))
	@printf "Downloading file $(FILE_VAR)..."
	@curl -s -S -L -f $(GITHUB)/$(FILE) -z $(FILE) -o $@ >$(LOG) 2>&1; \
	mv -n $@ $(FILE) >>$(LOG) 2>&1; \
	$(RESULT)

#%/.dummy: ## Makes a special empty file for marking that a directory tree has been generated.
#	@printf "Making directory tree for marker file $(TARGET_VAR)..."
#	@printf "Making marker file $(TARGET_VAR) and its directory tree..."
#	@mkdir -p $(@D); $(RESULT)
#	@printf "Making marker file $(TARGET_VAR)..."
#	@touch $@; $(RESULT)

.git: | $(LOG) ## Makes a git repository.
	@printf "Initializing git repository..."
	@git init >$(LOG) 2>&1; \
	$(RESULT)

.github/CODE_OF_CONDUCT.md: CODE_OF_CONDUCT.md.download ## Makes a CODE_OF_CONDUCT.md file.

.github/CONTRIBUTING.md: CONTRIBUTING.md.download ## Makes a CONTRIBUTING.md file.

.github/ISSUE_TEMPLATE/bug_report.md: bug_report.md.download ## Makes a bug_report.md file.

.github/ISSUE_TEMPLATE/custom.md: custom.md.download ## Makes a custom.md file.

.github/ISSUE_TEMPLATE/feature_request.md: feature_request.md.download ## Makes a feature_request.md file.

.gitignore: .gitignore.download ## Makes a .gitignore file.

Cartfile: | $(LOG) # Makes a Cartfile file for listing runtime Carthage dependencies.
	@printf "Making empty file $(TARGET_VAR)..."
	@touch $@ >$(LOG) 2>&1; \
	$(RESULT)

Cartfile.private: | $(LOG) # Makes a Cartfile file for listing private Carthage dependencies.
	@printf "Making empty file $(TARGET_VAR)..."
	@touch $@ >$(LOG) 2>&1; \
	$(RESULT)

CHANGELOG.md: CHANGELOG.md.download ## Makes a CHANGELOG.md file.

Framework.podspec: Framework.podspec.download ## Makes a Framework.podspec file.

ISSUE_TEMPLATE.md: ISSUE_TEMPLATE.md.download ## Makes a ISSUE_TEMPLATE.md file.

README.md: ISSUE_TEMPLATE.md.download ## Makes a README.md file.

REFERENCES.md: REFERENCES.md.download ## Makes a REFERRENCES.md file.

setup: setup.download ## Makes a setup file.

SUPPORT.md: SUPPORT.md.download ## Makes a SUPPORT.md file.

# ==============================================================================
# Intermediate Targets
#
# An intermediate target corresponds to a file that is needed on the way from a
# source file to a target file.  It typically is a temporary file that is needed
# only once to generate the target after the source changed.  The "make" command
# automatically removes files that are identified as intermediate targets.  In
# other words, such files that did not exist before a "make" run executed do not
# exist after a "make" run.
# ==============================================================================

.INTERMEDIATE: .gitignore.download

.INTERMEDIATE: bug_report.md.download

.INTERMEDIATE: CHANGELOG.md.download

.INTERMEDIATE: CODE_OF_CONDUCT.md.download

.INTERMEDIATE: CONTRIBUTING.md.download

.INTERMEDIATE: custom.md.download

.INTERMEDIATE: feature_request.md.download

.INTERMEDIATE: Framework.podspec.download

.INTERMEDIATE: ISSUE_TEMPLATE.md.download

.INTERMEDIATE: README.md.download

.INTERMEDIATE: REFERENCES.md.download

.INTERMEDIATE: SUPPORT.md.download

.INTERMEDIATE: $(LOG)

$(LOG): ## Makes a temporary file capturring a shell command error.
	@touch $@

# ==============================================================================
# Second Expansion Targets
# ==============================================================================

#.SECONDEXPANSION:
#$(PREFIX)/%.dummy: $$(@D)/.dummy | $$(@D)/. ## Make a directory tree.
