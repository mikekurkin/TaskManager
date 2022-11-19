#!/bin/sh

export RAILS_HOST=$UFFIZZI_URL
bundle exec sidekiq -C /task_manager/config/sidekiq.yml
