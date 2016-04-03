#!/system/bin/sh
#!/system/xbin/sh
 ################################################################
 # $ID: load-modules.sh Ò», 20  2ÔÂ 2012 22:14:53 +0800  mhfan $ #
 #                                                              #
 # Description:                                                 #
 #                                                              #
 # Maintainer:  ·¶ÃÀ»Ô(MeiHui FAN)  <mhfan@ustc.edu>            #
 #                                                              #
 # CopyLeft (c)  2012  M.H.Fan                                  #
 #   All rights reserved.                                       #
 #                                                              #
 # This file is free software;                                  #
 #   you are free to modify and/or redistribute it  	        #
 #   under the terms of the GNU General Public Licence (GPL).   #
 ################################################################

#MODEL=`getprop ro.product.model`
#MODEL=${MODEL#SmartQ}
#MODEL=${MODEL# }
MODEL=X7

# TODO: load modules on needed
echo "loading kernel modules"
cd /system/lib/modules/kernel

#insmod drivers/power/power_supply.ko
#insmod drivers/power/max8903_charger.ko &

# T19/T20/T30 has the same PCB
  if false; then true;
elif test $MODEL = T19; then MODEL=T20;
elif test $MODEL = K7;  then MODEL=S7 && HAS_BT=yes && HAS_WL12XX=yes;
elif test $MODEL = X7;  then MODEL=S7 && HAS_BT=yes && HAS_WL12XX=yes;
elif test $MODEL = T30; then MODEL=T20; fi

  if true; then true;
elif test $MODEL = T15 -o $MODEL = Q8; then
insmod drivers/power/oz8806.ko
insmod drivers/power/hhcn_charger.ko &
elif test $MODEL = T20; then
insmod drivers/power/bq2416x_charger.ko
insmod drivers/power/bq27410_battery.ko &
else
insmod drivers/mfd/twl6030-gpadc.ko
insmod drivers/power/twl6030_bci_battery.ko &
fi

if  test "`getprop ro.bootmode`" = charger; then
    test "`getprop ro.debuggable`" = 1 && setprop ctl.start console
    insmod drivers/usb/gadget/g_android.ko	# XXX:
    exit 0
fi

# early for netd
insmod net/netfilter/x_tables.ko
insmod net/netfilter/xt_quota2.ko &
insmod net/ipv4/netfilter/ip_tables.ko

insmod drivers/misc/gcx/gccore/gccore.ko
insmod drivers/misc/gcx/gcbv/gcbv2d.ko
insmod drivers/video/omap2/omaplfb/omaplfb.ko && start pvrsrvinit &
insmod drivers/misc/gcx/gcioctl/gcioctl.ko &

if false && test "`getprop ro.product.processor`" -e omap4470; then
#insmod /system/lib/modules/omaplfb_sgx544_122.ko
insmod /system/lib/modules/pvrsrvkm_sgx544_122.ko &
#else
#insmod /system/lib/modules/omaplfb_sgx540_120.ko
insmod /system/lib/modules/pvrsrvkm_sgx540_120.ko &
fi

if true; then
insmod drivers/mfd/mfd-core.ko
insmod drivers/mfd/twl6040_codec.ko

insmod sound/soundcore.ko
insmod sound/core/snd.ko
insmod sound/core/snd-timer.ko
insmod sound/core/snd-page-alloc.ko
insmod sound/core/snd-pcm.ko
insmod sound/soc/snd-soc-core.ko

test $MODEL = T20 &&
insmod drivers/misc/twl6040-vib.ko &

insmod sound/soc/codecs/snd-soc-twl6040.ko
insmod sound/soc/omap/snd-soc-omap.ko &

insmod sound/soc/codecs/snd-soc-dmic.ko &
insmod sound/soc/omap/snd-soc-omap-dmic.ko &

insmod sound/soc/omap/abe/snd-soc-abe-hal.ko
insmod sound/soc/omap/snd-soc-omap-abe-dsp.ko
insmod sound/soc/omap/snd-soc-omap-abe.ko
insmod sound/soc/omap/snd-soc-omap-mcpdm.ko &
insmod sound/soc/omap/snd-soc-omap-mcbsp.ko &
insmod sound/soc/omap/snd-soc-omap-vxrec.ko &
insmod sound/soc/omap/snd-soc-sdp4430.ko &
fi

#insmod drivers/hwspinlock/hwspinlock_core.ko
#insmod drivers/hwspinlock/omap_hwspinlock.ko &

#insmod drivers/rpmsg/virtio_rpmsg_bus.ko
#insmod drivers/rpmsg/rpmsg_resmgr.ko
#insmod drivers/rpmsg/rpmsg_omx.ko &

#insmod drivers/rtc/rtc-twl.ko &
insmod drivers/watchdog/omap_wdt.ko &
insmod drivers/usb/gadget/g_android.ko &

insmod net/packet/af_packet.ko &

insmod net/ipv4/netfilter/iptable_filter.ko &
insmod net/ipv4/netfilter/iptable_mangle.ko &
insmod net/ipv4/netfilter/iptable_raw.ko &
insmod net/ipv4/netfilter/ipt_REJECT.ko &

insmod net/ipv4/netfilter/nf_defrag_ipv4.ko
insmod net/netfilter/nf_tproxy_core.ko

insmod net/ipv6/ipv6.ko
insmod net/ipv6/netfilter/ip6_tables.ko
insmod net/ipv6/netfilter/nf_defrag_ipv6.ko

insmod net/netfilter/xt_socket.ko
insmod net/netfilter/qtaguid_xt.ko &

insmod net/ipv6/netfilter/ip6table_filter.ko &
insmod net/ipv6/netfilter/ip6table_mangle.ko &
insmod net/ipv6/netfilter/ip6table_raw.ko &
insmod net/ipv6/netfilter/ip6t_REJECT.ko &

  if false; then true;
elif test $MODEL = T15; then
HAS_BT=yes
#V4L_CAMERA=yes
insmod drivers/switch/switch_gpio.ko &
insmod drivers/input/touchscreen/goodix_touch.ko &
elif test $MODEL = T20; then
insmod drivers/input/touchscreen/ssd2533.ko &
insmod drivers/input/misc/isl29023.ko &
insmod drivers/switch/switch_gpio.ko &
HAS_HDMI=yes
HAS_BT=yes
elif test $MODEL = Q8; then
HAS_HDMI=yes
insmod drivers/input/touchscreen/pixcir_i2c_ts.ko &
elif test $MODEL = S7; then
HAS_HDMI=yes
insmod drivers/input/touchscreen/ft5x0x_i2c_ts.ko &
cat /data/data/com.android.systemui/files/persist.sys.capacity > \
/sys/devices/platform/omap/omap_i2c.1/i2c-1/1-0049/twl6030_bci/last_capacity
elif test $MODEL = T16; then
HAS_BT=yes
HAS_HDMI=yes
HAS_WL12XX=yes
insmod drivers/input/touchscreen/novatek_ts.ko
fi

insmod crypto/crypto_algapi.ko
insmod crypto/crypto_hash.ko
insmod crypto/crypto_blkcipher.ko

insmod crypto/aes_generic.ko &
insmod crypto/arc4.ko &
insmod crypto/ecb.ko &

insmod drivers/hid/hid.ko
insmod net/rfkill/rfkill.ko
insmod net/wireless/cfg80211.ko &

if test "$HAS_BT" = yes; then
insmod drivers/hid/uhid.ko &
insmod net/bluetooth/bluetooth.ko
insmod net/bluetooth/bnep/bnep.ko &
insmod net/bluetooth/hidp/hidp.ko &
insmod net/bluetooth/rfcomm/rfcomm.ko &

insmod drivers/bluetooth/hci_uart.ko &
#insmod drivers/bluetooth/btusb.ko &
#insmod drivers/misc/wl127x-rfkill.ko &

test "$HAS_WL12XX" = yes ||
insmod drivers/bluetooth/bcm43xx-bluetooth.ko &
fi

if test "$HAS_WL12XX" = yes; then
insmod compat/compat.ko &
insmod net/mac80211/mac80211.ko &

insmod drivers/misc/ti-st/st_drv.ko
insmod drivers/bluetooth/btwilink.ko &
insmod drivers/misc/ti-st/gps_drv.ko &

insmod drivers/media/video/videodev.ko
insmod drivers/media/video/v4l2-common.ko &
insmod drivers/media/video/v4l2-int-device.ko &
insmod drivers/media/radio/wl128x/fm_drv.ko &

#insmod drivers/mfd/wl1273-core.ko
#insmod drivers/net/wireless/wl12xx/wl12xx.ko
#insmod drivers/net/wireless/wl12xx/wl12xx_sdio.ko &
fi

#insmod net/wireless/lib80211.ko &

#insmod drivers/net/wireless/bcmdhd/bcmdhd.ko &
#insmod drivers/net/wireless/bcm4330/bcm4330.ko &
#insmod drivers/net/wireless/bcm4330/bcm4330.ko &

#insmod drivers/input/keyboard/gpio_keys.ko &
#insmod drivers/input/keyboard/gpio_keys_polled.ko &
#insmod drivers/input/keyboard/omap4-keypad.ko &
#insmod drivers/input/misc/gpio-event.ko &

#insmod drivers/input/misc/keychord.ko &
insmod drivers/input/misc/uinput.ko &
#insmod drivers/input/keyreset.ko &

insmod drivers/misc/hhcn_encrypy.ko &

insmod drivers/input/misc/bma250.ko &
insmod drivers/input/misc/mma8452.ko &
#insmod drivers/misc/sensors/mma7455.ko
#insmod drivers/misc/sensors/mecs.ko &

insmod fs/fuse/fuse.ko &

if test "$HAS_HDMI" = yes; then
insmod sound/soc/codecs/snd-soc-omap-hdmi-codec.ko &
insmod sound/soc/omap/snd-soc-omap4-hdmi.ko &
insmod sound/soc/omap/snd-soc-omap-hdmi.ko &
fi

if test "$V4L_CAMERA" = yes; then
insmod drivers/media/media.ko
insmod drivers/media/video/videodev.ko
insmod drivers/media/video/v4l2-common.ko
insmod drivers/media/video/videobuf2-core.ko
insmod drivers/media/video/videobuf2-memops.ko
insmod drivers/media/video/videobuf2-dma-contig.ko

insmod drivers/media/video/ov2655.ko &
insmod drivers/media/video/ov5640.ko &
#insmod drivers/media/video/ov5650.ko &

insmod drivers/media/video/omap4iss/omap4-iss.ko &
#insmod drivers/media/video/uvc/uvcvideo.ko

insmod drivers/media/video/videobuf-core.ko
#insmod drivers/media/video/videobuf-dma-contig.ko
insmod drivers/media/video/soc_mediabus.ko
insmod drivers/media/video/soc_camera.ko

insmod drivers/media/video/omap4_camera.ko &
fi

#insmod drivers/misc/omap_temp_sensor.ko &
#insmod arch/arm/mach-omap2/pcb_temp_sensor_device.ko &
#insmod drivers/staging/thermal_framework/thermal_framework.ko
#insmod drivers/staging/thermal_framework/omap4_duty_cycle.ko
#insmod drivers/staging/thermal_framework/governor/omap4_duty_cycle_governor.ko
#insmod drivers/staging/thermal_framework/governor/omap_die_governor.ko &
#insmod drivers/staging/thermal_framework/sensor/omap_temp_sensor.ko &
#insmod drivers/staging/thermal_framework/sensor/pcb_temp_sensor.ko &
#insmod drivers/staging/thermal_framework/sensor/tmp102_temp_sensor.ko &
insmod drivers/staging/thermal_framework/sensor/tmp103_temp_sensor.ko &

for M in drivers/cpufreq/cpufreq_*.ko; do insmod $M & done
insmod block/deadline-iosched.ko &
setprop kernel.module.status ok

insmod fs/fat/fat.ko
insmod fs/fat/vfat.ko &
#insmod fs/aufs/aufs.ko &
insmod ../extra/aufs.ko &
insmod fs/nls/nls_cp437.ko &
insmod fs/nls/nls_utf8.ko &
#insmod fs/fat/msdos.ko &
#insmod fs/ntfs/ntfs.ko &

insmod crypto/crypto_wq.ko
insmod crypto/aead.ko
insmod crypto/rng.ko
insmod crypto/krng.ko &
insmod crypto/eseqiv.ko &
insmod crypto/chainiv.ko &
insmod crypto/cryptomgr.ko &
insmod crypto/twofish_common.ko
insmod crypto/twofish_generic.ko &
insmod crypto/cbc.ko &

insmod drivers/md/dm-mod.ko
insmod drivers/block/loop.ko &
insmod drivers/md/dm-crypt.ko &

#insmod drivers/i2c/i2c-dev.ko &
#insmod drivers/gpio/basic_mmio_gpio.ko &

insmod lib/lzo/lzo_compress.ko
insmod drivers/staging/zram/zram.ko &
insmod drivers/staging/zcache/zcache.ko &

insmod drivers/input/mousedev.ko &
insmod drivers/hid/usbhid/usbhid.ko &
#insmod drivers/hid/usbhid/usbkbd.ko &
#insmod drivers/hid/usbhid/usbmouse.ko &
#insmod drivers/hid/hid-magicmouse.ko &
#insmod drivers/hid/hid-apple.ko &

insmod drivers/scsi/scsi_mod.ko
insmod drivers/scsi/sd_mod.ko
insmod drivers/usb/storage/usb-storage.ko
for M in drivers/usb/storage/ums-*.ko \
	 drivers/usb/storage/uas.ko; do insmod $M & done

insmod net/phonet/phonet.ko
insmod net/phonet/pn_pep.ko

insmod drivers/net/mii.ko
insmod drivers/net/usb/usbnet.ko
insmod drivers/net/usb/cdc_ether.ko
for M in drivers/net/usb/*.ko; do insmod $M & done #2> /dev/null

insmod net/llc/llc.ko
insmod net/802/stp.ko
insmod net/bridge/bridge.ko &

insmod drivers/net/tun.ko &
insmod net/netfilter/xt_tcpudp.ko &
insmod net/netfilter/nf_conntrack.ko
insmod net/ipv4/netfilter/nf_conntrack_ipv4.ko
insmod net/ipv4/netfilter/nf_nat.ko
insmod net/ipv4/netfilter/iptable_nat.ko &
insmod net/ipv4/netfilter/ipt_REDIRECT.ko &
insmod net/ipv4/netfilter/ipt_MASQUERADE.ko &
insmod net/netfilter/xt_state.ko &

insmod net/netfilter/nfnetlink.ko
insmod net/netfilter/nfnetlink_queue.ko &
insmod net/netfilter/nf_conntrack_netlink.ko &
insmod net/netfilter/nfnetlink_log.ko
insmod net/netfilter/xt_NFLOG.ko &

insmod net/xfrm/xfrm_ipcomp.ko
insmod net/xfrm/xfrm_user.ko &
insmod net/ipv4/ipcomp.ko &
insmod net/ipv4/ah4.ko &
insmod net/ipv4/esp4.ko &
insmod net/key/af_key.ko &
insmod net/ipv4/tunnel4.ko
insmod net/ipv4/ipip.ko &
insmod net/ipv4/xfrm4_tunnel.ko &
insmod net/ipv4/xfrm4_mode_transport.ko &
insmod net/ipv4/xfrm4_mode_tunnel.ko &
insmod net/ipv4/xfrm4_mode_beet.ko &
insmod net/netfilter/xt_esp.ko &
insmod net/netfilter/xt_policy.ko &
insmod net/ipv4/netfilter/ipt_ah.ko &

insmod crypto/sha1_generic.ko &
insmod crypto/des_generic.ko &
insmod crypto/crypto_null.ko &
insmod crypto/authenc.ko &
insmod crypto/hmac.ko &
insmod crypto/md5.ko &

insmod drivers/input/joydev.ko &

if test -x /system/bin/pppd; then
insmod drivers/cdrom/cdrom.ko
insmod drivers/scsi/sr_mod.ko &

insmod drivers/usb/class/cdc-acm.ko &
insmod drivers/usb/serial/usbserial.ko
insmod drivers/usb/serial/usb_wwan.ko
insmod drivers/usb/serial/option.ko &

insmod lib/crc-ccitt.ko
insmod lib/zlib_inflate/zlib_inflate.ko
insmod lib/zlib_deflate/zlib_deflate.ko

insmod crypto/deflate.ko &

insmod net/ipv4/gre.ko
insmod drivers/net/slhc.ko
insmod drivers/net/ppp_generic.ko
insmod drivers/net/pppox.ko
insmod drivers/net/pppoe.ko &
insmod drivers/net/pptp.ko &
insmod drivers/net/ppp_async.ko &
#insmod drivers/net/ppp_synctty.ko &
insmod drivers/net/bsd_comp.ko &
insmod drivers/net/ppp_mppe.ko &
insmod drivers/net/pppolac.ko &
insmod drivers/net/pppopns.ko &

insmod net/l2tp/l2tp_core.ko
insmod net/l2tp/l2tp_ppp.ko &
fi

if false; then	# XXX:
insmod fs/fscache/fscache.ko
insmod fs/cachefiles/cachefiles.ko &
insmod fs/cifs/cifs.ko &
insmod crypto/md4.ko &
fi

test $MODEL = T15 && test ! -e /sys/bus/i2c/devices/4-0055/version &&
(rmmod goodix_touch; insmod drivers/input/touchscreen/ssd2533.ko) &

setprop ctl.start cryptomem
mount -o remount,ro /system

wait && echo "all kernel modules loaded"

#echo 0 > /proc/sys/kernel/printk
test "`getprop ro.product.processor`" = omap4430 &&
echo 1 > /sys/module/cpuidle44xx/parameters/max_state

while ! setprop kernel.module.status ok; do sleep 1; done
test -e /system/bin/avahi-daemon && setprop ctl.start dbus &&
    (avahi-daemon -k; setprop ctl.start avahi-daemon)
test -e /proc/swaps && setprop ctl.start compcache
#ln -s /data/srec /system/usr/srec
setprop ctl.start cryptomem

setprop sys.usb.config none
echo "`getprop ro.product.brand` `getprop ro.product.model`" > \
	/sys/class/android_usb/android0/iProduct
setprop sys.usb.config `getprop persist.sys.usb.config`

test $MODEL = T15 && test ! -e /sys/bus/i2c/devices/4-0055/version &&
		     test ! -e /sys/bus/i2c/devices/4-0048/version &&
(rmmod ssd2533; insmod drivers/input/touchscreen/ft5x0x_i2c_ts.ko) &

test "$HAS_WL12XX" != yes && test "$HAS_BT" = yes &&
    (/system/bin/bdt -download || setprop ctl.start hciattach)

 # vim:sts=4:ts=8:
