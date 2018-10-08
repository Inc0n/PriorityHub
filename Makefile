export ARCHS = arm64
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 10.0
TARGET = iphone:clang:latest:9.0

DEBUG = 1
# GO_EASY_ON_ME = 1
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

SOURCE_FILES=$(wildcard tweak/*.m tweak/*.mm tweak/*.x tweak/*.xm)

TWEAK_NAME = PriorityHub
$(TWEAK_NAME)_FILES = $(SOURCE_FILES)
$(TWEAK_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = BulletinBoard
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += priorityhubpref
include $(THEOS_MAKE_PATH)/aggregate.mk

repo::
	@rm  packages/*.deb
	make package
	@cp packages/*.deb ~/Sites/repo/public/debs/
	@update_repo

after-install::
	install.exec "killall -9 SpringBoard"
