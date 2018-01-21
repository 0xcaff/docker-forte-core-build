# Taken from https://github.com/rust-lang-nursery/docker-rust/blob/e382ab252c238ab77f0b6e45b0705ba94b4e9e1d/1.23.0/stretch/Dockerfile
FROM buildpack-deps:stretch

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
		rustArch='x86_64-unknown-linux-gnu' \
    rustupSha256='4b7a67cd971d713e0caef48b5754190aca19192d1863927a005c3432512b12dc' \
    url="https://static.rust-lang.org/rustup/archive/1.9.0/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly-2018-01-20; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    cargo install --force clippy rustfmt-nightly;
