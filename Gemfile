# frozen_string_literal: true

source 'https://rubygems.org'

gem 'hanami', '~> 2.0'
gem 'hanami-router', '~> 2.0'
gem 'hanami-controller', '~> 2.0'
gem 'hanami-validations', '~> 2.0'

gem 'dry-types', '~> 1.0', '>= 1.6.1'
gem 'puma'
gem 'rake'

gem 'graphql', '~> 2.0'
gem 'active_utils', '~> 3.3', '>= 3.3.19'

gem 'freight_kit-next', git: 'https://github.com/next-tms/freight_kit-next', tag: 'v0.0.1'

gem 'honeybadger'

group :development, :test do
  gem 'dotenv'
end

group :cli, :development do
  gem 'hanami-reloader'
end

group :cli, :development, :test do
  gem 'hanami-rspec'
  gem 'rubocop-next', '~> 1.0.4'
end

group :development do
  gem 'guard-puma', '~> 0.8'
end

group :test do
  gem 'rack-test'
end
