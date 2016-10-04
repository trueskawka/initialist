require 'bundler'
Bundler.require
require './main'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

# load the Database and User model
require './model'

run Sinatra::Application
