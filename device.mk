#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

PRODUCT_COPY_FILES := \
	device/ti/beagleboneblack/init.am335xevm.rc:root/init.am335xevm.rc \
	device/ti/beagleboneblack/init.am335xevm.usb.rc:root/init.am335xevm.usb.rc \
	device/ti/beagleboneblack/vold.fstab:system/etc/vold.fstab \
	device/ti/beagleboneblack/fstab.am335xevm:root/fstab.am335xevm \
	device/ti/beagleboneblack/ueventd.am335xevm.rc:root/ueventd.am335xevm.rc \
	device/ti/beagleboneblack/media_codecs.xml:system/etc/media_codecs.xml \
	device/ti/beagleboneblack/media_profiles.xml:system/etc/media_profiles.xml \
	device/ti/beagleboneblack/mixer_paths.xml:system/etc/mixer_paths.xml \
	device/ti/beagleboneblack/audio_policy.conf:system/etc/audio_policy.conf

# Bluetooth support
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml

# WLAN station support
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml

# WLAN p2p support
# TODO: hardware/libhardware_legacy/wifi/wifi.c needs to be patched in order to support p2p
#PRODUCT_COPY_FILES += \
#	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

# Touchscreen
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml

# KeyPads
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/ti-tsc.idc:system/usr/idc/ti-tsc.idc

PRODUCT_PROPERTY_OVERRIDES := \
       hwui.render_dirty_regions=false

# Explicitly specify dpi, otherwise the icons don't show up correctly with SGX enabled
PRODUCT_PROPERTY_OVERRIDES += \
       ro.sf.lcd_density=160

PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.strictmode.visual=0 \
	persist.sys.strictmode.disable=1

PRODUCT_CHARACTERISTICS := tablet,nosdcard

DEVICE_PACKAGE_OVERLAYS := \
    device/ti/beagleboneblack/overlay

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_PACKAGES += \
	librs_jni \
	com.android.future.usb.accessory

PRODUCT_PACKAGES += \
	libaudioutils

PRODUCT_PACKAGES += \
	audio.primary.beagleboneblack \
	tinycap \
	tinymix \
	tinyplay

PRODUCT_PACKAGES += \
	dhcpcd.conf

# Filesystem management tools
PRODUCT_PACKAGES += \
	make_ext4fs

# Backlight HAL (liblights)
PRODUCT_PACKAGES += \
	lights.beagleboneblack

PRODUCT_PACKAGES += \
	FileManager-1.1.6

PRODUCT_PACKAGES += \
	androidvncserver

PRODUCT_PACKAGES += \
	camera.omap3

# BT
PRODUCT_PACKAGES += \
	libbt-vendor \
	uim-sysfs

# Bluetooth A2DP
PRODUCT_PACKAGES += \
	audio.a2dp.default

# WIFI
PRODUCT_PROPERTY_OVERRIDES += \
	wifi.interface=wlan0

PRODUCT_PACKAGES += \
	hostapd.conf

$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)
$(call inherit-product-if-exists, hardware/ti/wpan/wl12xx-bluetooth/wl12xx_bt_products.mk)
$(call inherit-product-if-exists, hardware/ti/wlan/mac80211/firmware/wl12xx_wlan_fw_products.mk)
