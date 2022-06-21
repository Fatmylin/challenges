source 'https://rubygems.org'

ruby '2.6.10'
gem 'rails', '~> 6.1.3.1'
gem 'sqlite3'
gem 'puma'
gem 'jbuilder'

# Serializer
gem 'blueprinter'

# Search
gem "elasticsearch", "< 7.14"
gem 'elasticsearch-model', '~> 7.1.0'
gem 'elasticsearch-rails', '~> 7.1.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'faker'
  gem 'pry'
  gem 'factory_bot_rails'
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'timecop'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
