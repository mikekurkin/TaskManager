FROM ruby:2.7.1-alpine

ARG RAILS_ROOT=/task_manager

ARG RAILS_ENV

ARG PACKAGES="vim openssl-dev postgresql-dev build-base curl nodejs yarn less tzdata git postgresql-client bash screen gcompat"

RUN apk update \
 && apk upgrade \
 && apk add --update --no-cache $PACKAGES

RUN gem install bundler:2.1.4

RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile.lock ./

RUN if [[ "$RAILS_ENV" = "production" ]]; then \
    bundle config deployment true \
 && bundle config without 'development test' \
; fi

RUN bundle install --jobs 5

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

ADD . $RAILS_ROOT
ENV PATH=$RAILS_ROOT/bin:${PATH}

RUN if [[ "$RAILS_ENV" = "production" ]]; then \
    export SECRET_KEY_BASE=$(bundle exec rake secret) \
 && bundle exec rails assets:precompile \
; fi

EXPOSE 3000
CMD bundle exec rails s -b '0.0.0.0' -p 3000
