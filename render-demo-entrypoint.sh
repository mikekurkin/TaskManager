#!/bin/sh

bundle exec rails db:prepare
if [ ! -z "$REPLANT_SEED" ]; then
    DISABLE_DATABASE_ENVIRONMENT_CHECK=1 \
    bundle exec rails db:seed:replant
    export REPLANT_SEED=''
fi
bundle exec rails server
