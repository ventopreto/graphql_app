source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.4"

gem "rails", "~> 6.1.7", ">= 6.1.7.8"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "bootsnap", ">= 1.4.4", require: false

group :development, :test do
  gem "standard"
  gem "standard-rails"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 4.1.2"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# graphql
gem "graphql", "~> 2.3"
gem "graphiql-rails"

# Rabbit
gem 'sneakers'
gem "bunny", ">= 2.19.0"
