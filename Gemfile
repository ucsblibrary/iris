source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'coffee-rails', '~> 4.2'
gem 'darlingtonia'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'dotenv-rails'
gem 'geo_works', git: 'https://github.com/samvera-labs/geo_works.git'
gem 'hyrax'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'loofah', '~> 2.2', '>= 2.2.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.6'
gem 'rsolr', '>= 1.0'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'sqlite3'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'bixby' # bixby == the hydra community's rubocop rules
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'capistrano'
  gem 'capistrano-bundler', '~> 1.3'
  gem 'capistrano-ext'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-sidekiq', '~> 0.20.0'
  gem 'database_cleaner'
  gem 'fcrepo_wrapper'
  gem 'hyrax-spec', "~> 0.3.2"
  gem 'method_source'
  gem 'pry'
  gem 'pry-doc'
  gem 'rspec-rails'
  gem 'solr_wrapper', '> 1.2.0'
end

group :test do
  gem 'coveralls', require: false
end
