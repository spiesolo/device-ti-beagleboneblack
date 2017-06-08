empty :=
space := $(empty) $(empty)
comma := ,

overlaydir := device/ti/beagleboneblack/overlay

subdir_makefiles := \
    $(shell build/tools/findleaves.py --prune=.repo --prune=.git $(overlaydir) overlay.mk)

$(foreach mk, $(subdir_makefiles), $(info including $(mk) ...)$(eval include $(mk)))

.PHONY: apply
apply:
	@$(foreach overlay, $(PRODUCT_OVERLAY_FILES), \
		$(eval _dir := $(word 1,$(subst :,$(space),$(overlay)))) \
		$(eval _patch := $(addprefix $(overlaydir)/, $(word 2,$(subst :,$(space),$(overlay))))) \
		$(info applying patch $(_patch) to $(_dir)) \
		$(shell git apply --directory $(_dir) $(_patch)))
