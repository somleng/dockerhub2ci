source "https://rubygems.org"

ruby(File.read(".ruby-version").strip)

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "coffee-rails", "~> 4.2"
gem "jbuilder", "~> 2.9"
gem "jquery-rails"
gem "pg", "~> 1.1"
gem "puma", "~> 4.0"
gem "rails", "~> 5.0.7"
gem "sass-rails", "~> 6.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"

gem "httparty"
gem "responders"
gem "sucker_punch"
gem "wisper"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "factory_girl_rails"
  gem "pry"
  gem "rspec-rails"
end

group :development do
  gem "listen", "~> 3.1.5"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "codecov", require: false
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "vcr"
  gem "webmock"
  gem "wisper-rspec"
end
