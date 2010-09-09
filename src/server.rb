require 'sinatra/base'

require 'db'

class Server < Sinatra::Base
  set :sessions, true
  set :public, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/views'
  set :db, Db.new

  get '/about' do
    haml :about
  end

  get '/catalogues' do
    @catalogues = settings.db.catalogues
    haml :catalogue_list
  end

  get '/stylesheets/style.css' do
    sass :style
  end

end