FROM dmotte/desktainer-rootless

# Create custom user named "mainuser"
RUN useradd \
    --create-home \
    --shell /bin/bash \
    --user-group \
    mainuser

ENV USER=mainuser HOME=/home/mainuser

WORKDIR /home/mainuser

ENV RESOLUTION=1920x1080
ENV VNC_PASSWORD=mainuser
