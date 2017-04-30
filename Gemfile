# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.2'
gem 'sqlite3'

# Used for throttling requests
gem 'rack-throttler', git: 'https://github.com/lfportal/rack-throttler.git'
gem 'redis', '~> 3.3'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5.2'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'rubocop', '~> 0.48.1', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'timecop', '~> 0.8'
end
