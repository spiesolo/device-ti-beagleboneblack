TARGET_PRODUCT := beagleboneblack
OMAPES := 4.x

# Component Path Configuration
export TARGET_PRODUCT
export OMAPES
export ANDROID_INSTALL_DIR := $(shell pwd)
export ANDROID_FS_DIR := $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT)/android_rootfs
export PATH :=$(PATH):$(ANDROID_INSTALL_DIR)/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin
export TOOL_MKTARBALL := $(if $(wildcard $(ANDROID_INSTALL_DIR)/device/ti/$(TARGET_PRODUCT)/mktarball.sh), \
                            $(ANDROID_INSTALL_DIR)/device/ti/$(TARGET_PRODUCT)/mktarball.sh, \
                            $(ANDROID_INSTALL_DIR)/build/tools/mktarball.sh)

kernel_not_configured := $(wildcard kernel/.config)

ifeq ($(TARGET_PRODUCT), am335xevm_sk)
rowboat: sgx wl12xx_compat
CLEAN_RULE = sgx_clean wl12xx_compat_clean kernel_clean clean
else
ifeq ($(TARGET_PRODUCT), beagleboneblack)
rowboat: sgx
CLEAN_RULE = sgx_clean kernel_clean clean
else
ifeq ($(TARGET_PRODUCT), beaglebone)
rowboat: sgx
CLEAN_RULE = sgx_clean kernel_clean clean
else
ifeq ($(TARGET_PRODUCT), am335xevm)
rowboat: sgx wl12xx_compat
CLEAN_RULE = sgx_clean wl12xx_compat_clean kernel_clean clean
else
ifeq ($(TARGET_PRODUCT), beagleboard)
rowboat: sgx
CLEAN_RULE = sgx_clean kernel_clean clean
else
ifeq ($(TARGET_PRODUCT), omap3evm)
rowboat: sgx wl12xx_compat
CLEAN_RULE = sgx_clean wl12xx_compat_clean kernel_clean clean
else
ifeq ($(TARGET_PRODUCT), flashboard)
rowboat: sgx wl12xx_compat
CLEAN_RULE = sgx_clean wl12xx_compat_clean kernel_clean clean
else
rowboat: kernel_build
endif
endif
endif
endif
endif
endif
endif

kernel_build: droid
ifeq ($(strip $(kernel_not_configured)),)
ifeq ($(TARGET_PRODUCT), am335xevm_sk)
	$(MAKE) -C kernel ARCH=arm am335x_evm_android_defconfig
endif
ifeq ($(TARGET_PRODUCT), beagleboneblack)
	$(MAKE) -C kernel ARCH=arm am335x_evm_android_defconfig
endif
ifeq ($(TARGET_PRODUCT), beaglebone)
	$(MAKE) -C kernel ARCH=arm am335x_evm_android_defconfig
endif
ifeq ($(TARGET_PRODUCT), am335xevm)
	$(MAKE) -C kernel ARCH=arm am335x_evm_android_defconfig
endif
ifeq ($(TARGET_PRODUCT), beagleboard)
	$(MAKE) -C kernel ARCH=arm omap3_beagle_android_defconfig
endif
ifeq ($(TARGET_PRODUCT), omap3evm)
	$(MAKE) -C kernel ARCH=arm omap3_evm_android_defconfig
endif
ifeq ($(TARGET_PRODUCT), flashboard)
	$(MAKE) -C kernel ARCH=arm flashboard_android_defconfig
endif
endif
	$(MAKE) -C kernel ARCH=arm CROSS_COMPILE=arm-eabi- uImage

kernel_clean:
	$(MAKE) -C kernel ARCH=arm  distclean

### DO NOT EDIT THIS FILE ###
include build/core/main.mk
### DO NOT EDIT THIS FILE ###

sgx: kernel_build
	$(MAKE) -C hardware/ti/sgx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) OMAPES=$(OMAPES)
	$(MAKE) -C hardware/ti/sgx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) OMAPES=$(OMAPES) install

sgx_clean:
	$(MAKE) -C hardware/ti/sgx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) OMAPES=$(OMAPES) clean

ifeq ($(WILINK), wl18xx)
wl12xx_compat: kernel_build
	$(MAKE) -C hardware/ti/wlan/mac80211/compat_wl18xx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) CROSS_COMPILE=arm-eabi- ARCH=arm install

wl12xx_compat_clean:
	$(MAKE) -C hardware/ti/wlan/mac80211/compat_wl18xx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) CROSS_COMPILE=arm-eabi- ARCH=arm clean
else
wl12xx_compat: kernel_build
	$(MAKE) -C hardware/ti/wlan/mac80211/compat_wl12xx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) CROSS_COMPILE=arm-eabi- ARCH=arm install

wl12xx_compat_clean:
	$(MAKE) -C hardware/ti/wlan/mac80211/compat_wl12xx ANDROID_ROOT_DIR=$(ANDROID_INSTALL_DIR) CROSS_COMPILE=arm-eabi- ARCH=arm clean
endif

u-boot_build:
ifeq ($(TARGET_PRODUCT), beagleboneblack)
	$(MAKE) -C u-boot ARCH=arm am335x_evm_config
endif
ifeq ($(TARGET_PRODUCT), beaglebone)
	$(MAKE) -C u-boot ARCH=arm am335x_evm_config
endif
ifeq ($(TARGET_PRODUCT), am335xevm_sk)
	$(MAKE) -C u-boot ARCH=arm am335x_evm_config
endif
ifeq ($(TARGET_PRODUCT), am335xevm)
	$(MAKE) -C u-boot ARCH=arm am335x_evm_config
endif
ifeq ($(TARGET_PRODUCT), beagleboard)
	$(MAKE) -C u-boot ARCH=arm omap3_beagle_config
endif
ifeq ($(TARGET_PRODUCT), omap3evm)
	$(MAKE) -C u-boot ARCH=arm omap3_evm_config
endif
ifeq ($(TARGET_PRODUCT), flashboard)
	$(MAKE) -C u-boot ARCH=arm flashboard_config
endif
	$(MAKE) -C u-boot ARCH=arm CROSS_COMPILE=arm-eabi-

u-boot_clean:
	$(MAKE) -C u-boot ARCH=arm CROSS_COMPILE=arm-eabi- distclean

# x-loader is required only for AM37x-based devices
# TODO: Handle non-supported devices gracefully
x-loader_build:
ifeq ($(TARGET_PRODUCT), beagleboard)
	$(MAKE) -C x-loader ARCH=arm omap3beagle_config
endif
ifeq ($(TARGET_PRODUCT), omap3evm)
	$(MAKE) -C x-loader ARCH=arm omap3evm_config
endif
ifeq ($(TARGET_PRODUCT), flashboard)
	$(MAKE) -C x-loader ARCH=arm flashboard_config
endif
	$(MAKE) -C x-loader ARCH=arm CROSS_COMPILE=arm-eabi-
	$(ANDROID_INSTALL_DIR)/external/ti_android_utilities/am37x/signGP/signGP x-loader/x-load.bin
	mv x-loader/x-load.bin.ift x-loader/MLO

x-loader_clean:
	$(MAKE) -C x-loader ARCH=arm CROSS_COMPILE=arm-eabi- distclean

# Make a tarball for the filesystem
fs_tarball: rowboat
	rm -rf $(ANDROID_FS_DIR)
	mkdir $(ANDROID_FS_DIR)
	cp -r $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT)/root/* $(ANDROID_FS_DIR)
	cp -r $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT)/system/ $(ANDROID_FS_DIR)
	(cd $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT); \
	$(TOOL_MKTARBALL) ../../../host/linux-x86/bin/fs_get_stats android_rootfs . rootfs rootfs.tar.bz2)

# Make NFS tarball of the filesystem
nfs_tarball:
	rm -rf $(ANDROID_FS_DIR)
	mkdir $(ANDROID_FS_DIR)
	cp -r $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT)/root/* $(ANDROID_FS_DIR)
	cp -r $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT)/system/ $(ANDROID_FS_DIR)
	(cd $(ANDROID_INSTALL_DIR)/out/target/product/$(TARGET_PRODUCT); \
	tar cvjf nfs-rootfs.tar.bz2 android_rootfs)

rowboat_clean: $(CLEAN_RULE)

sdcard_build: u-boot_build fs_tarball
	$(ANDROID_INSTALL_DIR)/external/ti_android_utilities/make_distribution.sh $(ANDROID_INSTALL_DIR) $(TARGET_PRODUCT)