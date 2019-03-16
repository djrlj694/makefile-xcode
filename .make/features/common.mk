# common.mk
# Copyright © 2019 Synthelytics LLC. All rights reserved.
#
# ==============================================================================
# PROGRAM: common.mk
# AUTHORS: Robert L. Jones
# COMPANY: Synthelytics LLC
# VERSION: 1.0.0
# CREATED: 03MAR2019
# REVISED: 16MAR2019
#
# NOTES:
#   For more info on terminology, style conventions, or source references, see
#   the file ".make/README.md".
# ==============================================================================

# ==============================================================================
# Internal Constants
# ==============================================================================

# ------------------------------------------------------------------------------
# Files
# ------------------------------------------------------------------------------

COMMON_DOCS := README REFERENCES

COMMON_FILES := $(addsuffix .md,$(COMMON_DOCS))
COMMON_DOWNLOADED_FILES := $(addsuffix .download,$(COMMON_FILES))

# ==============================================================================
# Phony Targets
# ==============================================================================

# ------------------------------------------------------------------------------
# Prerequisite phony targets for the "clean" target
# ------------------------------------------------------------------------------

.PHONY: clean-common clean-docs-common

## clean-common: Completes all Xcode cleanup activities.
clean-common: clean-docs-common

## clean-docs-common: Completes all common document cleanup activities.
clean-docs-common: | $(LOG)
	@printf "Removing common documents..."
	@rm -rf $(COMMON_FILES) 2>&1; \
	$(status_result)

# ------------------------------------------------------------------------------
# Prerequisite phony targets for the "docs" target
# ------------------------------------------------------------------------------

.PHONY: docs-common 

## docs-common: Completes all common document generation activites.
docs-common: $(COMMON_FILES)

# ------------------------------------------------------------------------------
# Prerequisite phony targets for the "init" target
# ------------------------------------------------------------------------------

.PHONY: init-common

## init-common: Completes all initial common setup activites.
ifeq ($(COOKIECUTTER),)
init-common: docs-common
endif

# ==============================================================================
# File Targets
# ==============================================================================

## README.md: Makes a README.md file.
README.md: README.sed README.md.download
	$(update-file)

# Makes a sed script for file README.sed.
README.sed:
	@echo $(PROJECT_CMD) >> $@
	@echo $(EMAIL_CMD) >> $@
	@echo $(GITHUB_USER_CMD) >> $@
	@echo $(TRAVIS_USER_CMD) >> $@

## REFERENCES.md: Makes a REFERENCES.md file.
REFERENCES.md: REFERENCES.md.download

# ==============================================================================
# Intermediate Targets
# ==============================================================================

.INTERMEDIATE: $(COMMON_DOWNLOADED_FILES) README.sed