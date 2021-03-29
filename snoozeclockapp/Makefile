TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = MobileTimer


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SnoozeClockApp

SnoozeClockApp_FILES = Tweak.x SNZPPEditViewController.m SNZPPEditView.m SNZPPBedtimeAlarmsTableViewController.m SNZPPAlarmTableViewCell.m
SnoozeClockApp_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
