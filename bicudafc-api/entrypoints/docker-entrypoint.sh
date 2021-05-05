#!/bin/sh
set -Eeuo pipefail
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

export BUNDLER_VERSION="$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
exec $@

bundle exec rails s -b 0.0.0.0