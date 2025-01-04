#!/bin/bash

set -e

########################### VARIABLES AND FUNCTIONS ############################

# Ensure that the HOME environment variable is defined
: "${HOME:?}"

readonly resolution=${RESOLUTION:-1920x1080}

readonly vnc_pass=${VNC_PASS:-}
unset VNC_PASS
readonly vnc_port=${VNC_PORT:-5901}
readonly novnc_port=${NOVNC_PORT:-6901}

withprefix() { while read -r i; do echo "$1$i"; done }

################### INCLUDE SCRIPTS FROM /opt/startup-early ####################

for i in /opt/startup-early/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

############################# VNC SERVER PASSWORD ##############################

if [ -n "$vnc_pass" ]; then
    if [ ! -f "$HOME/.vnc/passwd" ]; then
        echo "Storing the VNC password into $HOME/.vnc/passwd"

        mkdir -p "$HOME/.vnc"

        # Store the password encrypted and with 400 permissions
        x11vnc -storepasswd "$vnc_pass" "$HOME/.vnc/passwd"
        chmod 400 "$HOME/.vnc/passwd"
    fi

    echo 'VNC password will be enabled'
    vncpwoption=-usepw
else
    echo 'VNC password will be disabled'
    vncpwoption=-nopw
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
/usr/bin/Xvfb :0 -screen 0 "${resolution}x24" -nolisten tcp \
    -nolisten unix 2>&1 | withprefix 'Xvfb: ' &
sleep 2

echo 'Starting LXDE'
DISPLAY=:0 /usr/bin/startlxde 2>&1 | withprefix 'LXDE: ' &
sleep 2

echo 'Starting x11vnc'
/usr/bin/x11vnc -display :0 -xkb -forever -shared -repeat -capslock \
    -rfbport "$vnc_port" "$vncpwoption" 2>&1 | withprefix 'x11vnc: ' &
sleep 2

echo 'Starting noVNC'
/usr/bin/websockify --web=/usr/share/novnc "$novnc_port" \
    "127.0.0.1:$vnc_port" 2>&1 | withprefix 'noVNC: ' &

wait # until all jobs finish
trap - EXIT
