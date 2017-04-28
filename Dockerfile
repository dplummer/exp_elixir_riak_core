FROM ubuntu:16.04

ENV \
  EDITOR=vim \
  LANG=C.UTF-8 \
  OTP_VERSION="19.2.3" \
  ELIXIR_VERSION="v1.4.1"

ENV \
  OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-$OTP_VERSION.tar.gz" \
  ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip"

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

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix local.rebar rebar3 /src/rebar3/rebar3 --force

ENV APP_HOME /src/dist_cache
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD mix.exs mix.lock $APP_HOME/
RUN mix deps.get
RUN env
RUN mix deps.compile

ADD config $APP_HOME/priv/
ADD lib $APP_HOME/lib/
ADD priv $APP_HOME/config/
ADD test $APP_HOME/test/

RUN mix compile
