# Copyright © 2019 djrlj694.dev. All rights reserved.
#==============================================================================#
# PROGRAM: setting_up.mk
# AUTHORS: Robert L. Jones
# COMPANY: djrlj694.dev
# VERSION: 1.0.0
# CREATED: 16MAR2019
# REVISED: 24MAY2019
#==============================================================================#
# For more info on terminology, style conventions, or source references, see
# the file ".make/README.md".
#==============================================================================#

#==============================================================================#
# INTERNAL CONSTANTS
#==============================================================================#

#------------------------------------------------------------------------------#
# Commands
#------------------------------------------------------------------------------#

# A shortcut representing the "mkdir" command with the "-p" option.
MKDIR := mkdir -p

#==============================================================================#
# INTERNAL VARIABLES
#==============================================================================#

#------------------------------------------------------------------------------#
# Directories
#------------------------------------------------------------------------------#

# Name of the subdirectory, represented by the current Makefile target being
# run. The shell command "basename" removes the parent directory, $(@D)), from
# the absolute path of the makefile target.
subdir = $(shell basename $(@D))

#------------------------------------------------------------------------------#
# Files
#------------------------------------------------------------------------------#

file = $(basename $@)

#------------------------------------------------------------------------------#
# Path strings
#------------------------------------------------------------------------------#

dir_var = $(FG_CYAN)$(@D)$(RESET)
###file_var = $(FG_CYAN)$(file)$(RESET) # RLJ: Commented out. 23FEEB2019, RRLJ
file_var = $(FG_CYAN)$(@F)$(RESET)
subdir_var = $(FG_CYAN)$(subdir)$(RESET)

# Color-formatted name of the current makefile target being run.
target_var = $(FG_CYAN)$@$(RESET)

#==============================================================================#
# DIRECTORY TARGETS
#==============================================================================#

# Makes a directory tree.
%/.: | $(LOG)
	@printf "Making directory tree $(dir_var)..."
	@$(MKDIR) $(@D) >$(LOG) 2>&1; \
	$(status_result)
