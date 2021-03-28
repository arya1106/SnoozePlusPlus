TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = mobiletimerd


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = snooze

snooze_FILES = Tweak.x
snooze_CFLAGS = -fobjc-arc

export ARCHS = arm64 arm64e

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += snoozeclockapp
include $(THEOS_MAKE_PATH)/aggregate.mk
