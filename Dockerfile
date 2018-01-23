FROM buildpack-deps:stretch

ARG NODE_VERSION=node_9.x

# Install dependencies to install dependencies.
RUN apt-get update && apt-get install --yes \
  gnupg2=2.1.18-8~deb9u1 \
  apt-transport-https=1.4.8

# Add node repository.
RUN curl --silent https://deb.nodesource.com/gpgkey/nodesource.gpg.key \
    | apt-key add - && \
  echo "deb https://deb.nodesource.com/${NODE_VERSION} stretch main" \
    | tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/${NODE_VERSION} stretch main" \
    | tee --append /etc/apt/sources.list.d/nodesource.list

# Add yarn repository.
RUN curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg \
    | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" \
    | tee /etc/apt/sources.list.d/yarn.list

# Install dependencies.
RUN apt-get update && \
  apt-get install --yes \
  nodejs=9.4.0-1nodesource1 \
  yarn=1.3.2-1

# Install Rust.
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
