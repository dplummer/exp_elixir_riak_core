FROM ubuntu:14.04

ENV \
  EDITOR=vim \
  LANG=C.UTF-8 \
  OTP_VERSION="18.3.4.4" \
  ELIXIR_VERSION="v1.3.4"

ENV \
  OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
  OTP_DOWNLOAD_SHA256="3956f5c4fcd05848c7fe048d5c4ef7eaf002a8312cba0674150c5a10ab0e9f04" \
  ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip" \
  ELIXIR_DOWNLOAD_SHA256="eac16c41b88e7293a31d6ca95b5d72eaec92349a1f16846344f7b88128587e10"

RUN set -xe \
  && apt-get update \
  && apt-get install -y --reinstall ca-certificates \
  && apt-get install -y \
  build-essential \
  autoconf \
  m4 \
  libncurses5-dev \
  libssh-dev \
  unixodbc-dev \
  libsnappy-dev \
  curl \
  git \
  vim \
  libodbc1 \
  libsctp1 \
  unixodbc-dev \
  libsctp-dev \
  unzip

RUN set -xe \
  && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
  && echo "$OTP_DOWNLOAD_SHA256 otp-src.tar.gz" | sha256sum -c - \
  && mkdir -p /usr/src/otp-src \
  && tar -xzf otp-src.tar.gz -C /usr/src/otp-src --strip-components=1 \
  && rm otp-src.tar.gz \
  && cd /usr/src/otp-src \
  && ./otp_build autoconf \
  && ./configure --enable-sctp \
  && make -j$(nproc) \
  && make install \
  && find /usr/local -name examples | xargs rm -rf

RUN set -xe \
  && curl -fSL -o elixir-precompiled.zip $ELIXIR_DOWNLOAD_URL \
  && echo "$ELIXIR_DOWNLOAD_SHA256 elixir-precompiled.zip" | sha256sum -c - \
  && unzip -d /usr/local elixir-precompiled.zip \
  && rm elixir-precompiled.zip

RUN \
  mkdir -p /src \
  && cd /src \
  && git clone https://github.com/erlang/rebar3.git \
  && cd rebar3 \
  && ./bootstrap \
  && ./rebar3 local install

ENV PATH=$PATH:/root/.cache/rebar3/bin

RUN mix local.hex --force && mix local.rebar rebar3 /src/rebar3/rebar3 --force

ENV APP_HOME /src/dist_cache
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD config $APP_HOME/config/
ADD test $APP_HOME/test/
ADD lib $APP_HOME/lib/
ADD mix.exs $APP_HOME/

RUN mix deps.get
RUN mix deps.compile
