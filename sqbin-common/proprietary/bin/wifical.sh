#! /system/bin/sh

WIFION=`getprop init.svc.wpa_supplicant`

case "$WIFION" in
  "running") echo " ********************************************************"
             echo " * Turn Wi-Fi OFF and launch the script for calibration *"
             echo " ********************************************************"
             exit;;
          *) echo " ******************************"
             echo " * Starting Wi-Fi calibration *"
             echo " ******************************";;
esac

TARGET_FW_DIR=/system/etc/firmware/ti-connectivity
TARGET_NVS_FILE=$TARGET_FW_DIR/wl1271-nvs.bin
TARGET_INI_FILE=/system/etc/wifi/RFMD_S_3.5.ini
WL12xx_MODULE=/system/lib/modules/kernel/drivers/net/wireless/wl12xx/wl12xx_sdio.ko

if [ -e $WL12xx_MODULE ];
then
    echo ""
else
    echo "********************************************************"
    echo "wl12xx_sdio module not found !!"
    echo "If this is omap5/wl18xx platform, Calibration is not needed"
    echo "********************************************************"
    exit
fi

# Remount system partition as rw
mount -o remount rw /system

# Remove old NVS file
mv $TARGET_NVS_FILE $TARGET_NVS_FILE.b

# Actual calibration...
# calibrator plt autocalibrate <dev> <module path> <ini file1> <nvs file> <mac addr>
# Leaving mac address field empty for random mac
calibrator plt autocalibrate wlan0 $WL12xx_MODULE $TARGET_INI_FILE $TARGET_NVS_FILE

if [ ! -r /system/etc/firmware/ti-connectivity/wl1271-nvs.bin ]; then
    echo "calibrated failed! use default instead."
    mv $TARGET_NVS_FILE.b $TARGET_NVS_FILE
else
    echo "calibrated success!"
    mv /system/bin/wifical.sh /system/bin/wifical.sh.b
fi

mount -o remount,ro /system

echo " ******************************"
echo " * Finished Wi-Fi calibration *"
echo " ******************************"
