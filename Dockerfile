FROM ruby:3.2.2-alpine3.18 AS runtime
RUN apk -U upgrade && apk add --no-cache libpq-dev libxml2 libxslt imagemagick

FROM runtime AS build
ARG BUNDLER_GITHUB_OAUTH_KEY

RUN apk add --no-cache build-base git

COPY . /app
WORKDIR /app

RUN apk add --no-cache --virtual .gem-installdeps build-base \
                                                  git \
                                                  imagemagick-c++ \
                                                  imagemagick-dev \
                                                  imagemagick-libs \
                                                  libxml2-dev \
                                                  libxslt-dev && \
    gem install bundler -v 2.4.10 && \
    gem install nokogiri --platform=ruby -- --use-system-libraries && \
    bundle config github.com $BUNDLER_GITHUB_OAUTH_KEY && \
    bundle install --retry 5 && \
    rm -rf /usr/local/bundle/cache && \
    apk del .gem-installdeps

FROM runtime
COPY --from=build /app /app
COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /app

ENV LANG=en_US.UTF-8
ENV HANAMI_ENV=production
ENV RACK_ENV=production

EXPOSE 2300
CMD ["bundle", "exec", "puma", "-b", "tcp://[::]:2300"]
