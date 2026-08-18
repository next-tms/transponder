# frozen_string_literal: true

source 'https://rubygems.org'

gem 'hanami', '~> 2.3.2'
gem 'hanami-router', '~> 2.3.1'
gem 'hanami-controller', '~> 2.3.2'
gem 'hanami-validations', '~> 2.3.0'

gem 'dry-types', '~> 1.0', '>= 1.6.1'
gem 'puma', '~> 8.0'
gem 'rake'

gem 'graphql', '~> 2.0'

# @note GraphQL types depend on these:
gem 'active_utils', '~> 3.3', '>= 3.3.19'
gem 'freight_kit', '~> 0.1.18'
gem 'mimemagic', '~> 0.4.3'
gem 'money', '~> 6.16.0'

gem 'honeybadger'

group :development, :test do
  gem 'dotenv'
end

group :cli, :development do
  gem 'hanami-reloader', '~> 2.3.0'
end

group :cli, :development, :test do
  gem 'faker', '~> 3.2.1'
  gem 'hanami-rspec', '~> 2.3.1'
  gem 'rubocop-next', '~> 1.0.7'
end

group :development do
  gem 'guard-puma', '~> 0.8'
end

group :test do
  gem 'rack-test'
end
