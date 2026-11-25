source 'https://rubygems.org'

gem 'hanami', '~> 2.3.2'
gem 'hanami-controller', '~> 2.3.2'
gem 'hanami-router', '~> 3.0.0'
gem 'hanami-validations', '~> 2.3.0'

gem 'dry-types', '~> 1.0', '>= 1.6.1'
gem 'puma', '~> 8.1'
gem 'rake'

gem 'graphql', '~> 2.6'

# @note GraphQL types depend on these:
gem 'active_utils', '~> 3.6'
gem 'freight_kit', '~> 0.1.27'
gem 'mimemagic', '~> 0.4.3'
gem 'money', '~> 7.1.1'

group :development, :test do
  gem 'dotenv'
end

group :cli, :development do
  gem 'hanami-reloader', '~> 3.0.0'
end

group :cli, :development, :test do
  gem 'faker', '~> 3.8.0'
  gem 'hanami-rspec', '~> 3.0.0'
  gem 'rubocop-next', '~> 1.0.11'
end

group :development do
  gem 'guard-puma', '~> 0.8'
end

group :test do
  gem 'rack-test'
end
