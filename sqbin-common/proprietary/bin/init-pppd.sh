#!/system/bin/sh

SCRIPT=`/system/bin/getprop ril.ppp.script`

/system/bin/log -t pppd "begin pppd call"

if busybox [ "$SCRIPT" = "wcdma" ] ; then
	pppd call wcdma 
elif busybox [ "$SCRIPT" = "cdma2000" ] ; then 
	pppd call cdma2000
elif busybox [ "$SCRIPT" = "td-scdma" ] ; then 
	pppd call td-scdma
fi

