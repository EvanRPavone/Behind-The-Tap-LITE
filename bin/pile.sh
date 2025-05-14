#!/bin/bash

export RAILS_ENV=${RAILS_ENV:-development}

echo "🔥 Clobbering old assets..."
bundle exec rails assets:clobber

echo "🚀 Precompiling assets..."
bundle exec rails assets:precompile

echo "🛠️ Running Yarn Build"
yarn build

echo "Running ESBuild Config"
node esbuild.config.js

if [[ "$RAILS_ENV" == "development" ]]; then
  echo "🚀 Starting Rails server..."
  bundle exec rails server
else
  echo "🌍 Skipping Rails server (Production/Heroku detected)."
fi

echo "✅ Done!"
