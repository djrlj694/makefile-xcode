# Copyright © 2019 djrlj694.dev. All rights reserved.
#==============================================================================#
# PROGRAM: sed.mk
# AUTHORS: Robert L. Jones
# COMPANY: djrlj694.dev
# VERSION: 1.0.0
# CREATED: 16MAR2019
# REVISED: 25MAY2019
#==============================================================================#
# For more info on terminology, style conventions, or source references, see
# the file ".make/README.md".
#==============================================================================#

#==============================================================================#
# MACROS
#==============================================================================#

# Runs a sed script ("$<") to transform a text file ("$@"), such as substituting
# regular expression pattern matches with replacement values.
define update-file
	@sed -f $< $@ > $@.tmp
	@mv $@.tmp $@
endef

#==============================================================================#
# USER-DEFINED FUNCTIONS
#==============================================================================#

# $(call add-sed-cmd,sed-cmd,kv_var)
# Generates and adds a sed command to a sed script ($@) from a single
# key/value pair.
define add-sed-cmd
	$(eval key = $(firstword $(subst :, ,$2)))
	$(eval value = $(word 2,$(subst :, ,$2)))
	$(eval sed_cmd = $(call $1,$(key),$(value)))
	@echo $(sed_cmd) >> $@
endef

# $(call add-sed-cmds,sed-cmd,kv_list)
# Generates and adds a list of syntactically identical sed commands to the same
# sed script from a list of key/value pairs.
add-sed-cmds = $(foreach kv_var,$2,$(call add-sed-cmd,$1,$(kv_var)))
