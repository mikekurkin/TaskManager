#!/bin/sh

bundle exec rails db:prepare
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 \
bundle exec rails db:seed:replant
bundle exec rails server
