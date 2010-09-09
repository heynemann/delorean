require 'rubygems'
require 'sinatra'
require 'db'

db = Db.new

get '/hi' do
  "Hello World!"
end