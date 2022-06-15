sed -i '/=m/d;/CONFIG_VERSION/d;/CONFIG_IB/d;/CONFIG_SDK/d;/CONFIG_BUILDBOT/d;/CONFIG_ALL_KMODS/d;/CONFIG_ALL_NONSHARED/d;/CONFIG_DISPLAY_SUPPORT/d;/CONFIG_AUDIO_SUPPORT/d;/CONFIG_AUTOREBUILD/d;/CONFIG_AUTOREMOVE/d;/CONFIG_MAKE_TOOLCHAIN/d;/CGROUPS/d;/PACKAGE_lib/d;/luci-lib/d;/luci-app/d;/LLVM/d;/vsftpd=/d;/docker/Id;' `find configs/ -type f` scripts/mk-friendlywrt.sh

ls configs/* | xargs -i echo -e '\nCONFIG_KERNEL_BUILD_USER="Dayong Chen"\nCONFIG_GRUB_TITLE="OpenWrt on Nanopi devices compiled by DayongChen"' >> configs/{}

cd friendlywrt/
line_number_CONFIG_CRYPTO_LIB_BLAKE2S=$[`grep -n 'CONFIG_CRYPTO_LIB_BLAKE2S' package/kernel/linux/modules/crypto.mk | cut -d: -f 1`+1]
sed -i $line_number_CONFIG_CRYPTO_LIB_BLAKE2S' s/HIDDEN:=1/DEPENDS:=@(LINUX_5_4||LINUX_5_10)/' package/kernel/linux/modules/crypto.mk
sed -i 's/libblake2s.ko@lt5.9/libblake2s.ko/;s/libblake2s-generic.ko@lt5.9/libblake2s-generic.ko/' package/kernel/linux/modules/crypto.mk
echo 'kmod-wireguard' >> `ls staging_dir/target-*/pkginfo/linux.default.install`
cd -