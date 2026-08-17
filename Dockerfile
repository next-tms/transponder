FROM ruby:3.4.9-alpine3.22 AS runtime
RUN apk -U upgrade
RUN apk add --no-cache libpq-dev libxml2 libxslt imagemagick shared-mime-info yaml

FROM runtime AS build

RUN apk add --no-cache --virtual .gem-installdeps build-base \
                                                  imagemagick-c++ \
                                                  imagemagick-dev \
                                                  imagemagick-libs \
                                                  libxml2-dev \
                                                  libxslt-dev \
                                                  yaml-dev

COPY ./Gemfile ./Gemfile.lock /app/

WORKDIR /app

RUN gem install bundler -v $(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | tr -d '[:space:]')
RUN bundle config set --global frozen 1 && \
    gem install nokogiri --platform=ruby -- --use-system-libraries && bundle install --jobs $(nproc) --retry 5 && \
    rm -rf /usr/local/bundle/cache && apk del .gem-installdeps

FROM runtime
COPY . /app
COPY --from=build /app/Gemfile.lock /app/Gemfile.lock
COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /app

ENV LANG=en_US.UTF-8
ENV HANAMI_ENV=production
ENV RACK_ENV=production

EXPOSE 2300
CMD ["bundle", "exec", "puma", "-b", "tcp://[::]:2300"]
