#!/bin/sh

rm -rf /task_manager/tmp/letter_opener/*
export RAILS_HOST=$UFFIZZI_URL
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed:replant
bundle exec rails assets:precompile
bundle exec rails server -b '0.0.0.0'
