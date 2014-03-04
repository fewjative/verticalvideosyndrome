ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = VerticalVideoSyndrome
VerticalVideoSyndrome_FILES = Tweak.xm
VerticalVideoSyndrome_FRAMEWORKS = UIKit Foundation
include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = VVS
VVS_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 Camera"
