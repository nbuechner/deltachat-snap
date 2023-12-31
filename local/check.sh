#!/usr/bin/env bash
snapctl is-connected camera
cam=$?

snapctl is-connected audio-record
record=$?

echo "CAM $cam"
echo "RECORD $record"

if [ "$record" == "0" ] && [ "$cam" == "0" ]; then
   exec "${@}"
fi

if [ -f $SNAP_USER_COMMON/.asked-permissions ]; then
   exec "${@}"
fi

zenity --question --title='Permissions required' \
   --text="`printf "To be able to scan QR codes and record voice messages this application needs some permissions.\nTo grant these permissions run\n\nsudo snap connect deltachat-desktop:camera\nsudo snap connect deltachat-desktop:audio-record\n\nin a terminal."`" --ok-label='OK' --cancel-label='Do not ask again'
ret=$?
if [[ "$ret" == "1" ]]; then
   echo $ret
   touch $SNAP_USER_COMMON/.asked-permissions
fi

exec "${@}"
