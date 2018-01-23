fortemusic/core-build
=====================

[![automated-build-badge]][docker-hub]

A docker image with the tools needed to compile and test [forte-music/core]. It
includes:

* a node environment with yarn
* a nightly rust toolchain (2018-01-20) along with clippy and rustfmt
* [wait-for]

[forte-music/core]: https://github.com/forte-music/core
[wait-for]: https://github.com/eficode/wait-for

[automated-build-badge]: https://img.shields.io/docker/automated/fortemusic/core-build.svg
[docker-hub]: https://hub.docker.com/r/fortemusic/core-build/
