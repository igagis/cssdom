ifeq ($(os),windows)
    # to avoid /C converted to C:\ need to escape it as //C
    this_test_cmd := (cd $(d)$(this_out_dir) && cmd //C 'set PATH=../../../../src/out/$(c);../../../harness/out/$(c);%PATH% && $$(notdir $$^)')
else ifeq ($(os),macosx)
    this_test_cmd := (cd $(d) && DYLD_LIBRARY_PATH=../../src/out/$(c):../harness/out/$(c) $(this_out_dir)/$$(notdir $$^))
else ifeq ($(os),linux)
    this_test_cmd := (cd $(d) && LD_LIBRARY_PATH=../../src/out/$(c):../harness/out/$(c) $(this_out_dir)/$$(notdir $$^))
else
    $(error "Unknown OS")
endif

define this_rule
test:: $(prorab_this_name)
$(.RECIPEPREFIX)@myci-running-test.sh $(notdir $(abspath $(d)))
$(.RECIPEPREFIX)$(a)$(this_test_cmd) || myci-error.sh "test failed"
$(.RECIPEPREFIX)@myci-passed.sh
endef
$(eval $(this_rule))

ifeq ($(os),windows)
    # to avoid /C converted to C:\ need to escape it as //C
    this_gdb_cmd := (cd $(d)$(this_out_dir) && cmd //C 'set PATH=../../../../src/out/$(c);../../../harness/out/$(c);%PATH% && gdb $$(notdir $$^)')
else ifeq ($(os),macosx)
    this_gdb_cmd := (cd $(d) && DYLD_LIBRARY_PATH=../../src/out/$(c):../harness/out/$(c) gdb $(this_out_dir)/$$(notdir $$^))
else ifeq ($(os),linux)
    this_gdb_cmd := (cd $(d) && LD_LIBRARY_PATH=../../src/out/$(c):../harness/out/$(c) gdb $(this_out_dir)/$$(notdir $$^))
endif

define this_rule
gdb:: $(prorab_this_name)
$(.RECIPEPREFIX)$(a)$(this_gdb_cmd)
endef
$(eval $(this_rule))
