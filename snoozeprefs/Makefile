TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SnoozePrefs

SnoozePrefs_FILES = $(wildcard *.m)
SnoozePrefs_FRAMEWORKS = UIKit
SnoozePrefs_PRIVATE_FRAMEWORKS = Preferences
SnoozePrefs_INSTALL_PATH = /Library/PreferenceBundles
SnoozePrefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/bundle.mk
