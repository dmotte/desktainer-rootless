FROM dmotte/desktainer-rootless

# Create custom user named "debian"
RUN useradd \
    --create-home \
    --shell /bin/bash \
    --user-group \
    debian

ENV USER=debian HOME=/home/debian

WORKDIR /home/debian

ENV RESOLUTION=1920x1080
ENV VNC_PASSWORD=debian
