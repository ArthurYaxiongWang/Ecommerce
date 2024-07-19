#!/bin/bash
set -e

# Run database migrations
bundle exec rake db:migrate

# Start the server
exec "$@"