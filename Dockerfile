

FROM quay.io/jupyter/base-notebook

# Set the Ruby version (default is 3.3.1)
ARG RUBY_VERSION=3.3.1
ENV RUBY_VERSION=${RUBY_VERSION}

# Install system packages needed for building Ruby
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libzmq3-dev \
    libreadline-dev \
    zlib1g-dev \
    libffi-dev \
    libtool \
    curl && \
    gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN pip install jupyter_scheduler
RUN pip install jupyterlab-spreadsheet-editor

USER root

# Download, compile, and install Ruby from source
RUN set -ex && \
    RUBY_DOWNLOAD_URL="https://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION%.*}/ruby-${RUBY_VERSION}.tar.gz" && \
    curl -fsSL "$RUBY_DOWNLOAD_URL" -o ruby.tar.gz && \
    tar -xzvf ruby.tar.gz && \
    cd ruby-${RUBY_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j"$(nproc)" && \
    make install && \
    cd .. && \
    rm -rf ruby-${RUBY_VERSION} ruby.tar.gz

# Verify Ruby installation
RUN ruby -v

# Install IRuby gem globally
RUN gem install iruby

# Register IRuby as a Jupyter kernel
RUN iruby register --force


RUN mkdir -p /home/jovyan/.local/share/jupyter/runtime && \
    chown -R jovyan:users /home/jovyan/.local

# Switch back to the default notebook user
USER $NB_UID
