#!/usr/bin/env bash
# exit on error
set -o errexit

# Add executable permission to rails script
chmod +x bin/rails

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean