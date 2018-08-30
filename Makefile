export ARCHS = arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 10.0
TARGET = iphone:clang:latest:9.0

DEBUG = 0
GO_EASY_ON_ME = 1

PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

SOURCE_FILES=$(wildcard tweak/*.m tweak/*.mm tweak/*.x tweak/*.xm)

TWEAK_NAME = PriorityHub
PriorityHub_FILES = $(SOURCE_FILES)
PriorityHub_FRAMEWORKS = UIKit CoreGraphics CoreTelephony QuartzCore
PriorityHub_CFLAGS = -fobjc-arc
PriorityHub_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/tweak.mk
# SUBPROJECTS += preferences
SUBPROJECTS += priorityhubpref
include $(THEOS_MAKE_PATH)/aggregate.mk

repo::
	@cp packages/*.deb ~/Sites/repo/public/debs/
	@update_repo

after-install::
	install.exec "killall -9 SpringBoard"
