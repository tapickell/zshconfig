#!/bin/sh
#
# Use: Put something this in your .tmux.conf file
# set -g status-right: '#(wifi-signal-strength)'
#

all_signal=(▁ ▃ ▅ ▇ )

current=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | egrep "agrCtlRSSI|state|lastTxRate| SSID" | cut -d: -f2 | tr "\\n" ";" | sed 's/^[ ]//g'`

if [ "$current" == "" ]
then
  echo "(WIFI off)"
fi

strength=`echo $current | cut -d";" -f1-1 | cut -d" " -f2-`
state=`echo $current | cut -d";" -f2-2 | cut -d" " -f2-`
bandwidth=`echo $current | cut -d";" -f3-3 | cut -d" " -f2-`
name=`echo $current | cut -d";" -f4-4 | cut -d" " -f2-`

if [ "$state" != "running" ]
then
  echo "(WIFI off)"
fi

signal="( "
for (( j = 0; j < 4; j++ ))
do
  if [[ $j -eq 0 && $strength -gt -94 ]] || [[ $j -eq 1 && $strength -gt -92 ]] ||
     [[ $j -eq 2 && $strength -gt -86 ]] || [[ $j -eq 3 && $strength -gt -79 ]]
  then
    signal="${signal}${all_signal[$j]} "
  else
    signal="${signal}  "
  fi
done
signal="${signal} )"

echo "${name} ${bandwidth}Mbs ${signal}"