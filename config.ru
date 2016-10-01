require 'bundler'
Bundler.require
require './main'

# configure :development do
#   DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
# end

DataMapper.setup(:default, ENV['HEROKU_POSTGRESQL_RED_URL'])

run Sinatra::Application
