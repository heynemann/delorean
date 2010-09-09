require 'db'

require 'sinatra/base'

class Server < Sinatra::Base
  set :sessions, true
  set :public, File.dirname(__FILE__) + '/public'
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