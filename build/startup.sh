#!/bin/bash

set -e

############################ ENVIRONMENT VARIABLES #############################

: "${VNC_PORT:=5901}"
: "${NOVNC_PORT:=6901}"
: "${RESOLUTION:=1920x1080}"

################### INCLUDE SCRIPTS FROM /opt/startup-early ####################

for i in /opt/startup-early/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

############################# VNC SERVER PASSWORD ##############################

if [ -n "$VNC_PASSWORD" ]; then
    if [ ! -f "$HOME/.vnc/passwd" ]; then
        echo "Storing the VNC password into $HOME/.vnc/passwd"

        mkdir -p "$HOME/.vnc"

        # Store the password encrypted and with 400 permissions
        x11vnc -storepasswd "$VNC_PASSWORD" "$HOME/.vnc/passwd"
        chmod 400 "$HOME/.vnc/passwd"
    fi

    unset VNC_PASSWORD

    VNCPWOPTION=-usepw
    echo 'VNC password set'
else
    VNCPWOPTION=-nopw
    echo 'VNC password disabled'
fi

############################# CLEAR Xvfb LOCK FILE #############################

rm -f /tmp/.X0-lock

#################### INCLUDE SCRIPTS FROM /opt/startup-late ####################

for i in /opt/startup-late/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

################################ START SERVICES ################################

trap 'kill $(jobs -p)' EXIT

echo 'Starting Xvfb'
/usr/bin/Xvfb :0 -screen 0 "${RESOLUTION}x24" -nolisten tcp -nolisten unix &
sleep 2

echo 'Starting LXDE'
DISPLAY=:0 /usr/bin/startlxde &
sleep 2

echo 'Starting x11vnc'
/usr/bin/x11vnc -display :0 -xkb -forever -shared -repeat -capslock \
    -rfbport "$VNC_PORT" "$VNCPWOPTION" &
sleep 2

echo 'Starting noVNC'
/usr/bin/websockify --web=/usr/share/novnc "$NOVNC_PORT" "127.0.0.1:$VNC_PORT" &

wait # until all jobs finish
trap - EXIT
