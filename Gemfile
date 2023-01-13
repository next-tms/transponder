# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 2.0"
gem "hanami-router", "~> 2.0"
gem "hanami-controller", "~> 2.0"
gem "hanami-validations", "~> 2.0"

gem "dry-types", "~> 1.0", ">= 1.6.1"
gem "puma"
gem "rake"

gem "graphql", "~> 2.0"

gem "interstellar", git: "https://github.com/next-tms/interstellar", branch: "master",
  ref: "a11f245c79f7bb826b0d68aea186a809ca336531"
gem "interstellar-next", git: "https://github.com/next-tms/interstellar-next", branch: "master",
  ref: "710ff8d68403e1a4fce65467f69d5b1cf134cf38"
gem "spacetime", git: "https://github.com/next-tms/spacetime", ref: "b430558c2458c6d674ec1803246ff5fcccacff94"

group :development, :test do
  gem "dotenv"
end

group :cli, :development do
  gem "hanami-reloader"
end

group :cli, :development, :test do
  gem "hanami-rspec"
  gem "rubocop-graphql", require: false
  gem "rubocop-rake", require: false
  gem "rubocop-shopify", "~> 2.10", require: false
end

group :development do
  gem "guard-puma", "~> 0.8"
end

group :test do
  gem "rack-test"
end
