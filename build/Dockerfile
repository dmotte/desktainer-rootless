FROM docker.io/library/debian:12

EXPOSE 5901 6901

# Note: dbus-x11 is needed for LXDE apps to work properly (see
# https://ubuntuforums.org/showthread.php?t=2360777)
# Note: at-spi2-core is needed for LXDE apps to work properly (see
# https://www.raspberrypi.org/forums/viewtopic.php?t=196070)
RUN apt-get update && \
    apt-get install -y novnc xvfb x11vnc dbus-x11 at-spi2-core && \
    apt-get install -y --no-install-recommends lxde && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=root:root --chmod=755 startup.sh /

ENV LC_ALL=C.UTF-8
RUN echo '#!/bin/bash\n\nexport LC_ALL=C.UTF-8' \
    > /etc/profile.d/set-c-utf8-locale.sh

# Some adjustments, including:
# - noVNC: if on ARM architecture, disable the Tight* encodings. See
#   https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/98 for further
#   information
# - LXDE: disable light-locker because it cannot run inside a container (it
#   would fail at startup and silently create a ~/core core dump file)
# - LXDE: disable polkit because of the "No session for pid ..." message box
#   (see https://github.com/WhitewaterFoundry/Pengwin/issues/429)
RUN arch=$(uname -m); \
    if [ "$arch" != "${arch#arm}" ]; then \
        sed -i 's/\(encs\.push[(]encodings\.encodingTight\)/\/\/ \1/' \
        /usr/share/novnc/core/rfb.js; \
    fi && \
    \
    mv -T /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
    \
    sed -i "s/\(WebUtil\.getConfigVar[(]'autoconnect', \)false/\1true/" \
    /usr/share/novnc/app/ui.js && \
    \
    update-alternatives --set x-terminal-emulator /usr/bin/lxterminal && \
    \
    rm /etc/xdg/autostart/light-locker.desktop && \
    \
    rm /etc/xdg/autostart/lxpolkit.desktop && \
    mv -T /usr/bin/lxpolkit /usr/bin/lxpolkit.bak

RUN useradd -Ums/bin/bash mainuser && \
    install -omainuser -gmainuser -dm700 /opt/startup-early /opt/startup-late

USER mainuser
ENV USER=mainuser HOME=/home/mainuser
WORKDIR /home/mainuser

ENTRYPOINT ["/startup.sh"]
