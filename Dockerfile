FROM buildpack-deps:buster

# Add wait-for.
RUN curl --output /bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/fd4909a3b269d05bd5fe13d0e5d2b9b1bc119323/wait-for && \
    chmod +x /bin/wait-for

# Section: Node
ARG NODE_VERSION=node_14.x

# Add node and yarn repositories
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
        | apt-key add - && \
    echo "deb https://deb.nodesource.com/${NODE_VERSION} buster main" \
        | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/${NODE_VERSION} buster main" \
        | tee --append /etc/apt/sources.list.d/nodesource.list && \
    curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg \
        | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" \
        | tee /etc/apt/sources.list.d/yarn.list

# Install dependencies.
RUN apt-get update && \
  apt-get install --yes \
  nodejs \
  yarn \
  netcat-openbsd \
  cmake \
  clang \
  zlib1g-dev

# Setup Rust variables and versions.
ARG rustToolchain='1.48.0'
ARG rustupVersion='1.23.1'

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    rustArch='x86_64-unknown-linux-gnu'

# Install Rust.
RUN set -eux; \
    url="https://static.rust-lang.org/rustup/archive/${rustupVersion}/${rustArch}/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain "${rustToolchain}"; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

# Install Diesel CLI
RUN cargo install diesel_cli --no-default-features --features "sqlite"
