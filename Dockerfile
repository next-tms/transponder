FROM golang:1.26.4-alpine3.23 AS caddy
ARG CADDY_VERSION=2.11.2
ARG GOPROXY

RUN apk -U upgrade
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@v0.4.5

WORKDIR /src
ENV XCADDY_GO_BUILD_FLAGS='-trimpath -ldflags "-s -w -extldflags -static" -tags "osusergo,netgo"'
RUN /go/bin/xcaddy build v$CADDY_VERSION --with github.com/ueffel/caddy-brotli

FROM ruby:4.0.6-alpine3.24 AS runtime
RUN apk --no-cache upgrade && apk add --no-cache curl libpq-dev libxml2 libxslt imagemagick shared-mime-info yaml

FROM runtime AS build
ARG BUNDLE_MIRROR__ALL
ARG BUNDLE_MIRROR__ALL__FALLBACK_TIMEOUT

RUN apk add --no-cache --virtual .gem-installdeps build-base \
                                                  imagemagick-c++ \
                                                  imagemagick-dev \
                                                  imagemagick-libs \
                                                  libxml2-dev \
                                                  libxslt-dev \
                                                  yaml-dev

COPY ./Gemfile ./Gemfile.lock /app/

WORKDIR /app

RUN gem install bundler -v $(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | tr -d '[:space:]') \
      ${BUNDLE_MIRROR__ALL:+--clear-sources --source $BUNDLE_MIRROR__ALL}
RUN bundle config set --global frozen 1 && \
    gem install nokogiri --platform=ruby ${BUNDLE_MIRROR__ALL:+--clear-sources --source $BUNDLE_MIRROR__ALL} -- --use-system-libraries && \
    bundle install --jobs $(nproc) --retry 5 && \
    rm -rf /usr/local/bundle/cache && apk del .gem-installdeps

FROM runtime
COPY . /app
COPY --from=build /app/Gemfile.lock /app/Gemfile.lock
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=caddy /src/caddy /usr/local/bin/caddy

WORKDIR /app

ENV LANG=en_US.UTF-8
ENV HANAMI_ENV=production
ENV PORT=2300
ENV PUMA_SOCKET=/run/transponder/puma.sock
ENV RACK_ENV=production

RUN addgroup -g 1000 transponder && adduser -u 1000 -G transponder -s /bin/sh -D transponder
RUN mkdir -p /run/transponder && chown transponder:transponder /run/transponder
RUN chown -R transponder:transponder /app
USER transponder

EXPOSE 2300
CMD ["./web.sh"]
