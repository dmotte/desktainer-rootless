#!/bin/bash

set -e

############################ ENVIRONMENT VARIABLES #############################

if [ -z "$HOME" ]; then
    echo "The HOME environment variable is not set" 1>&2
	exit 1
fi

VNC_PORT=${VNC_PORT:-5901}
NOVNC_PORT=${NOVNC_PORT:-6901}
RESOLUTION=${RESOLUTION:-1280x720}

############################# VNC SERVER PASSWORD ##############################

# If the VNC password should be set
if [ -n "$VNC_PASSWORD" ]; then
    # If the .vnc/passwd file doesn't exist
    if [ ! -f "$HOME/.vnc/passwd" ]; then
        echo "Storing the VNC password into $HOME/.vnc/passwd"

        mkdir -p "$HOME/.vnc"

        # Store the password (encrypted and with 400 permissions)
        x11vnc -storepasswd "$VNC_PASSWORD" "$HOME/.vnc/passwd"
        chmod 400 "$HOME/.vnc/passwd"
    fi

    unset VNC_PASSWORD

    VNCPWOPTION="-usepw"
    echo "VNC password set"
else
    VNCPWOPTION="-nopw"
    echo "VNC password disabled"
fi

############################# CLEAR Xvfb LOCK FILE #############################

# Remove the X11 lock file if present
rm -f /tmp/.X0-lock

################################ START SERVICES ################################

echo "Starting Xvfb"
/usr/bin/Xvfb :0 -screen 0 "${RESOLUTION}x24" -nolisten tcp -nolisten unix &
PID_XVFB=$!
sleep 2

echo "Starting LXDE"
DISPLAY=:0 /usr/bin/startlxde &
PID_LXDE=$!
sleep 2

echo "Starting x11vnc"
/usr/bin/x11vnc -display :0 -xkb -forever -shared -repeat -capslock \
    -rfbport "$VNC_PORT" "$VNCPWOPTION" &
PID_X11VNC=$!
sleep 2

echo "Starting noVNC"
/usr/bin/websockify --web=/usr/share/novnc "$NOVNC_PORT" "127.0.0.1:$VNC_PORT" &
PID_NOVNC=$!

wait "$PID_XVFB"
wait "$PID_LXDE"
wait "$PID_X11VNC"
wait "$PID_NOVNC"
