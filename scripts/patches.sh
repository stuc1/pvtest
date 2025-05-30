set -x
config_file_turboacc=`find package/ -follow -type f -path '*/luci-app-turboacc/root/etc/config/turboacc'`
sed -i "s/option hw_flow '1'/option hw_flow '0'/" $config_file_turboacc
sed -i "s/option sfe_flow '1'/option sfe_flow '0'/" $config_file_turboacc
sed -i "s/option sfe_bridge '1'/option sfe_bridge '0'/" $config_file_turboacc
sed -i "/dep.*INCLUDE_.*=n/d" `find package/ -follow -type f -path '*/luci-app-turboacc/Makefile'`

sed -i "s/option limit_enable '1'/option limit_enable '0'/" `find package/ -follow -type f -path '*/nft-qos/files/nft-qos.config'`
sed -i "s/option enabled '1'/option enabled '0'/" `find package/ -follow -type f -path '*/vsftpd-alt/files/vsftpd.uci'`
sed -i "/\/etc\/coremark\.sh/d" `find package/ -follow -type f -path '*/coremark/coremark'`
sed -i 's/192.168.1.1/192.168.2.1/' package/base-files/files/bin/config_generate
sed -i 's/=1/=0/g' package/kernel/linux/files/sysctl-br-netfilter.conf

sed -i '/DEPENDS+/ s/$/ +wsdd2/' `find package/ -follow -type f -path '*/ksmbd-tools/Makefile'`

sed -i 's/ +ntfs-3g/ +ntfs3-mount/' `find package/ -follow -type f -path '*/automount/Makefile'`
sed -i '/skip\=/ a skip=`mount | grep -q /dev/$device; echo $?`' `find package/ -follow -type f -path */automount/files/15-automount`

sed -i 's/START=95/START=99/' `find package/ -follow -type f -path */ddns-scripts/files/etc/init.d/ddns`

#sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=master/' package/kernel/rtl8821cu/Makefile
#sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=skip/' package/kernel/rtl8821cu/Makefile

# enable r2s oled plugin by default
sed -i "s/enable '0'/enable '1'/" `find package/ -follow -type f -path '*/luci-app-oled/root/etc/config/oled'`

# set default theme to argon
sed -i '/uci commit luci/i\uci set luci.main.mediaurlbase="/luci-static/argon"' `find package -type f -path '*/default-settings/files/*-default-settings'`

mkdir -p `find package/ -follow -type d -path '*/pdnsd-alt'`/patches
mv $GITHUB_WORKSPACE/patches/99-disallow-aaaa.patch `find package/ -follow -type d -path '*/pdnsd-alt'`/patches

# line_number_INCLUDE_Xray=$[`grep -m1 -n 'Include Xray' package/custom/openwrt-passwall/luci-app-passwall/Makefile|cut -d: -f1`-1]
# sed -i $line_number_INCLUDE_Xray'd' package/custom/openwrt-passwall/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_Xray'd' package/custom/openwrt-passwall/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_Xray'd' package/custom/openwrt-passwall/luci-app-passwall/Makefile
# line_number_INCLUDE_V2ray=$[`grep -m1 -n 'Include V2ray' package/custom/openwrt-passwall/luci-app-passwall/Makefile|cut -d: -f1`-1]
# sed -i $line_number_INCLUDE_V2ray'd' package/custom/openwrt-passwall/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_V2ray'd' package/custom/openwrt-passwall/luci-app-passwall/Makefile
# sed -i $line_number_INCLUDE_V2ray'd' package/custom/openwrt-passwall/luci-app-passwall/Makefile
# sed -i 's/LUCI_DEPENDS:=/LUCI_DEPENDS:=+iptables-mod-iprange +iptables-mod-socket /' package/custom/openwrt-passwall/luci-app-passwall/Makefile

# inject the firmware version
strDate=`TZ=UTC-8 date +%Y-%m-%d`
status_pages=`find package/ -follow -type f \( -path '*/autocore/files/arm/index.htm' -o -path '*/autocore/files/x86/index.htm' -o -path '*/autocore/files/arm/rpcd_10_system.js' -o -path '*/autocore/files/x86/rpcd_10_system.js' \)`
for status_page in $status_pages; do
case $status_page in
  *htm)
    line_number_FV=`grep -n 'Firmware Version' $status_page | cut -d: -f 1`
    sed -i '/ver\./d' $status_page
    sed -i $line_number_FV' a <a href="https://github.com/stupidloud/nanopi-openwrt" target="_blank">stupidloud/nanopi-openwrt</a> '$strDate $status_page
    ;;
  *js)
    line_number_FV=`grep -m1 -n 'var fields' $status_page | cut -d: -f1`
    sed -i $line_number_FV' i var pfv = document.createElement('\''placeholder'\'');pfv.innerHTML = '\''<a href="https://github.com/stupidloud/nanopi-openwrt" target="_blank">stupidloud/nanopi-openwrt</a> '$strDate"';" $status_page
    line_number_FV=`grep -n 'Firmware Version' $status_page | cut -d : -f 1`
    sed -i '/Firmware Version/d' $status_page
    sed -i $line_number_FV' a _('\''Firmware Version'\''), pfv,' $status_page
    ;;
esac
done

# fix po path for snapshot
#find package/ -follow -type d -path '*/po/zh-cn' | xargs dirname | xargs -ri sh -c "rm -f {}/zh_Hans; ln -sf zh-cn {}/zh_Hans"

# remove non-exist package from x86 profile
sed -i 's/kmod-i40evf//;s/kmod-iavf//' target/linux/x86/Makefile

# kernel:fix bios boot partition is under 1 MiB
# https://github.com/WYC-2020/lede/commit/fe628c4680115b27f1b39ccb27d73ff0dfeecdc2
sed -i 's/256/1024/' target/linux/x86/image/Makefile

# swap the network adapter driver to r8168 to gain better performance for r4s
#sed -i 's/r8169/r8168/' target/linux/rockchip/image/armv8.mk

# add pwm fan control service
wget https://github.com/friendlyarm/friendlywrt/commit/cebdc1f94dcd6363da3a5d7e1e69fd741b8b718e.patch
git apply cebdc1f94dcd6363da3a5d7e1e69fd741b8b718e.patch
rm cebdc1f94dcd6363da3a5d7e1e69fd741b8b718e.patch
sed -i 's/pwmchip1/pwmchip0/' target/linux/rockchip/armv8/base-files/usr/bin/fa-fancontrol.sh target/linux/rockchip/armv8/base-files/usr/bin/fa-fancontrol-direct.sh

# add r1s support to Lean's repo
if [[ $DEVICE == 'r1s' ]]; then
  #cd ~ && rm -rf immortalwrt/ && git clone -b openwrt-18.06-k5.4 --depth=1 https://github.com/immortalwrt/immortalwrt && cd immortalwrt
  #rsync -a --delete target/linux/sunxi/. ~/lede/target/linux/sunxi/. && rsync -a --delete package/boot/. ~/lede/package/boot/.
  #cd ~/lede
  #sed -i 's/kmod-rtl8189es//;s/wpad-basic-openssl/wpad-basic-wolfssl/' target/linux/sunxi/image/cortexa53.mk
  #git diff --summary
  #merge_package "-b openwrt-18.06-k5.4 https://github.com/immortalwrt/immortalwrt" immortalwrt/package/emortal/autocore

  sed -i '/luci/d' $GITHUB_WORKSPACE/common.seed $GITHUB_WORKSPACE/extra_packages.seed

  #git revert --no-commit f4405a9597eea92622b66f122de2fb738a605d5d 51459ab19ec99ac63090766dff5dbc8ae74ef714 
fi

# fix for r1s-h3
if [[ $DEVICE == 'r1s-h3' ]]; then
  sed -i 's/kmod-leds-gpio//' target/linux/sunxi/image/cortexa7.mk
fi


## ugly fix of the read-only issue
sed -i '3 i sed -i "/^exit.*/i\\/bin\\/mount -o remount,rw /" /etc/rc.local' `find package -type f -path '*/default-settings/files/*-default-settings'`
