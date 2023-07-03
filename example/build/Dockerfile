# Tested with docker.io/dmotte/desktainer-rootless:2023.06.27.0440
FROM docker.io/dmotte/desktainer-rootless:latest

# Create custom user named "mainuser"
RUN useradd \
    --create-home \
    --shell /bin/bash \
    --user-group \
    mainuser

ENV USER=mainuser HOME=/home/mainuser

WORKDIR /home/mainuser
