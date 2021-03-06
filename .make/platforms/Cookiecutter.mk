# Copyright © 2019 djrlj694.dev. All rights reserved.
#==============================================================================#
# PROGRAM: Cookiecutter.mk
# AUTHORS: Robert L. Jones
# COMPANY: djrlj694.dev
# VERSION: 1.0.0
# CREATED: 10MAR2019
# REVISED: 25MAY2019
#==============================================================================#
# For more info on terminology, style conventions, or source references, see
# the file ".make/README.md".
#==============================================================================#

#==============================================================================#
# EXTERNAL CONSTANTS
#==============================================================================#

#------------------------------------------------------------------------------#
# Command output
#------------------------------------------------------------------------------#

COOKIECUTTER ?= $(shell which cookiecutter)

#==============================================================================#
# INTERNAL CONSTANTS
#==============================================================================#

#------------------------------------------------------------------------------#
# Debugging & error capture
#------------------------------------------------------------------------------#

VARIABLES_TO_SHOW += COOKIECUTTER

#------------------------------------------------------------------------------#
# Help strings
#------------------------------------------------------------------------------#

MAKE_ARGS += [COOKIECUTTER=]

#==============================================================================#
# USER-DEFINED FUNCTIONS
#==============================================================================#

# $(call sed-cmd,cc_var,replacement)
# Generates a sed command for substituting a Cookiecutter template variable with
# a replacement value.
ifeq ($(COOKIECUTTER),)
cc-sed-cmd = s/{{cookiecutter.$1}}/$2/g
endif

#==============================================================================#
# UTILITY DEPENDENCIES
#==============================================================================#

ifeq ($(COOKIECUTTER),)
include $(MAKEFILE_DIR)/utilities/sed.mk
endif

#==============================================================================#
# FEATURE DEPENDENCIES
#==============================================================================#

ifeq ($(COOKIECUTTER),)
include $(MAKEFILE_DIR)/features/downloading.mk
include $(MAKEFILE_DIR)/features/setting_up.mk
endif
