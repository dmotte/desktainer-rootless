# desktainer-rootless

![icon](icon-128.png)

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/dmotte/desktainer-rootless/release?logo=github&style=flat-square)](https://github.com/dmotte/desktainer-rootless/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/dmotte/desktainer-rootless?logo=docker&style=flat-square)](https://hub.docker.com/r/dmotte/desktainer-rootless)

:computer: Remote **desk**top in a cont**ainer** (rootless version). This image is almost equivalent to [dmotte/desktainer](https://github.com/dmotte/desktainer) but it can be run as a **non-root user**.

> :package: This image is also on **Docker Hub** as [`dmotte/desktainer-rootless`](https://hub.docker.com/r/dmotte/desktainer-rootless) and runs on **several architectures** (e.g. amd64, arm64, ...). To see the full list of supported platforms, please refer to the [`.github/workflows/release.yml`](.github/workflows/release.yml) file. If you need an architecture which is currently unsupported, feel free to open an issue.

> :calendar: The build process of this Docker image is **triggered automatically every month** (thanks, [GitHub Actions](https://github.com/features/actions)! :smile:) to ensure that you get it with all the latest updated packages. See the [workflow file](.github/workflows/release.yml) for further information.

## Usage

The simplest way to try this image is:

```bash
docker run -it --rm -p 6901:6901 dmotte/desktainer-rootless
```

But this way the container will run as root. To run it as a non-root user, this image has to be extended. Take a look at [`test/Dockerfile`](test/Dockerfile) for an example.

So the simplest **sensible** way to try this image is:

```bash
docker build -t dtrl-test test
docker run -it --rm -p 6901:6901 -u mainuser dtrl-test
```

Then head over to http://localhost:6901/ to access the remote desktop.

![Screenshot](screen-01.png)

You can also use more advanced commands like this one:

```bash
docker run -it --rm -p 6901:6901 -h dtrl-test -u mainuser \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    dtrl-test
```

> :bulb: **Tip**: If you want to **change the resolution** while the container is running, you can use the `xrandr --fb 1024x768` command. The new resolution cannot be larger than the one specified in the `RESOLUTION` environment variable though.

> :bulb: **Tip**: if you need to run commands after the LXDE startup, you can create launcher files in the `/etc/xdg/autostart` or the `~/.config/autostart` directory.

### Environment variables

Same as the [dmotte/desktainer](https://github.com/dmotte/desktainer) project except that the `USER` and `PASSWORD` environment variables have no effect. This behaviour is intended, since the container should run as a non-root user.

## Development

If you want to contribute to this project, the first thing you have to do is to **clone this repository** on your local machine:

```bash
git clone https://github.com/dmotte/desktainer-rootless.git
```

Then you'll have to build the **base image**:

```bash
docker build -t dmotte/desktainer-rootless build
```

And then just refer to the [Usage](#usage) section for the next steps.
