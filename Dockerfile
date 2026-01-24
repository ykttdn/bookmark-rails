FROM ruby:4.0.1-slim-trixie

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq \
        build-essential \
        libyaml-dev \
        git \
        postgresql-client \
        libpq-dev && \
    rm -rf /var/lib/apt/lists/*

ARG BUNDLER_VERSION=4.0.3

RUN gem install bundler -v ${BUNDLER_VERSION}

WORKDIR /app

EXPOSE 8000

CMD [ "bash" ]
