# Carthage.mk
# Copyright © 2019 Synthelytics LLC. All rights reserved.
#
# ==============================================================================
# PROGRAM: Carthage.mk
# AUTHORS: Robert L. Jones
# COMPANY: Synthelytics LLC
# VERSION: 1.1.0
# CREATED: 04FEB2019
# REVISED: 23FEB2019
# ==============================================================================

# ==============================================================================
# Variables
# ==============================================================================

# Directories

# Files

CARTHAGE_FILES = Cartfile Cartfile.private

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

# Prerequisite phony targets for cleaning activities

.PHONY: clean-carthage

clean-carthage: | $(LOG) ## Completes all Carthage cleanup activities.
	@printf "Removing Carthage setup..."
	@rm -rf $(CARTHAGE_FILES) >$(LOG) 2>&1; \
	$(RESULT)

# Prerequisite phony targets for initial setup activities

.PHONY: init-carthage

init-carthage: $(CARTHAGE_FILES) ## Completes all initial Carthage setup activities.

# ==============================================================================
# File Targets
# ==============================================================================

Cartfile: | $(LOG) # Makes a Cartfile file for listing runtime Carthage dependencies.
	@printf "Making empty file $(TARGET_VAR)..."
	@touch $@ >$(LOG) 2>&1; \
	$(RESULT)

Cartfile.private: | $(LOG) # Makes a Cartfile file for listing private Carthage dependencies.
	@printf "Making empty file $(TARGET_VAR)..."
	@touch $@ >$(LOG) 2>&1; \
	$(RESULT)

setup: setup.download ## Makes a setup file.