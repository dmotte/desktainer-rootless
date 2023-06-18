# desktainer-rootless

![icon](icon-128.png)

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dmotte/desktainer-rootless/release.yml?branch=main&logo=github&style=flat-square)](https://github.com/dmotte/desktainer-rootless/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/desktainer-rootless?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/desktainer-rootless)

:computer: Remote **desk**top in a con**tainer** (rootless version). This image is almost equivalent to [dmotte/desktainer](https://github.com/dmotte/desktainer) but it can be run as a **non-root user**.

> :package: This image is also on **Docker Hub** as [`dmotte/desktainer-rootless`](https://hub.docker.com/r/dmotte/desktainer-rootless) and runs on **several architectures** (e.g. amd64, arm64, ...). To see the full list of supported platforms, please refer to the [`.github/workflows/release.yml`](.github/workflows/release.yml) file. If you need an architecture which is currently unsupported, feel free to open an issue.

## Simple usage

The simplest way to try this image is:

```bash
docker run -it --rm -p 6901:6901 dmotte/desktainer-rootless
```

> **Note**: since some GUI applications may have issues with Docker's default _seccomp_ profile, you may need to use `--security-opt seccomp=unconfined`

Then head over to http://localhost:6901/ to access the remote desktop.

![Screenshot](screen-01.png)

However, this way the container will run as root. To run it as a non-root user, this image has to be **extended**. Take a look at the [`example`](example) folder.

## More info

For more info see the [dmotte/desktainer](https://github.com/dmotte/desktainer) project, which is very similar to this one.

The environment variables are the same, except `USER` and `PASSWORD` which have no effect. This behaviour is intended, since this image should run as a non-root user.
