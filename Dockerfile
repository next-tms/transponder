FROM ruby:3.3.7-alpine3.21 AS runtime
RUN apk -U upgrade
RUN apk add --no-cache libpq-dev libxml2 libxslt imagemagick shared-mime-info

FROM runtime AS build
ARG BUNDLER_GITHUB_OAUTH_KEY

RUN apk add --no-cache build-base git

RUN apk add --no-cache --virtual .gem-installdeps build-base \
                                                  git \
                                                  imagemagick-c++ \
                                                  imagemagick-dev \
                                                  imagemagick-libs \
                                                  libxml2-dev \
                                                  libxslt-dev

COPY ./Gemfile /app/Gemfile

WORKDIR /app

RUN gem install bundler -v 2.5.11 && \
RUN bundle config github.com $BUNDLER_GITHUB_OAUTH_KEY
RUN gem install nokogiri --platform=ruby -- --use-system-libraries && \
    bundle install --jobs $(nproc) --retry 5
RUN rm -rf /usr/local/bundle/cache && apk del .gem-installdeps

FROM runtime
COPY . /app
COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /app

ENV LANG=en_US.UTF-8
ENV HANAMI_ENV=production
ENV RACK_ENV=production

EXPOSE 2300
CMD ["bundle", "exec", "puma", "-b", "tcp://[::]:2300"]
