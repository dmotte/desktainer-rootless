# desktainer-rootless

:construction: **Work in progress** :construction:

TODO

This repo is still under construction. Come back soon :)

```bash
docker build -t dmotte/desktainer-rootless build
docker build -t dtrl01 test
docker run -it --rm -p 6901:6901 -u debian dtrl01

docker run -it --rm -p 6901:6901 -h dtrl01 -u debian \
    -v /etc/timezone:/etc/timezone:ro \
    -v /etc/localtime:/etc/localtime:ro \
    dtrl01
```
