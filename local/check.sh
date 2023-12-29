#!/usr/bin/env bash
snapctl is-connected camera
cam=$?

echo "CAM $cam"

if [ -f $SNAP_USER_COMMON/.asked-permission-camera ] || [ "$cam" == "0" ]; then
   exec "${@}"
fi

zenity --question --title='Allow camera access' \
   --text="`printf "To be able to scan QR codes this applications needs camera access.\nTo grant this permission run\n\nsudo snap connect deltachat-desktop:camera\n\nin a terminal."`" --ok-label='OK' --cancel-label='Do not ask again'
ret=$?
if [[ "$ret" == "1" ]]; then
   echo $ret
   touch $SNAP_USER_COMMON/.asked-permission-camera
fi

exec "${@}"
