include $(TOPDIR)/rules.mk

PKG_NAME:=blue-merle-ax3000
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/blue-merle-ax3000
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Blue Merle (AX3000 port with auto AT detection)
  DEPENDS:=+python3-light +python3
endef

define Package/blue-merle-ax3000/description
  SRLabs Blue Merle ported to GL.iNet AX3000 (auto-detects modem AT port).
endef

define Build/Compile
	# no compilation needed
endef

define Package/blue-merle-ax3000/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/usr/bin/blue-merle $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/lib/blue-merle
	$(INSTALL_BIN) ./files/lib/blue-merle/functions.sh $(1)/lib/blue-merle/
	$(INSTALL_BIN) ./files/lib/blue-merle/imei_generate.py $(1)/lib/blue-merle/
endef

$(eval $(call BuildPackage,blue-merle-ax3000))
