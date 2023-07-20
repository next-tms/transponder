FROM ruby:3.2.2-alpine3.18

RUN apk add --no-cache build-base git

WORKDIR /app
COPY . /app
RUN bundle install -j $(nproc) --quiet

ENV LANG=en_US.UTF-8
ENV HANAMI_ENV=production
ENV RACK_ENV=production

EXPOSE 2300
ENTRYPOINT ["bundle", "exec", "puma", "-b", "tcp://[::]:2300"]
