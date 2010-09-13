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
    params['catalogues'] = settings.db.catalogues
    haml :catalogue_list
  end

  get '/catalogues/new' do
    haml :catalogue_new
  end

  post '/catalogues/create' do
    name = params[:name]
    settings.db.create_catalogue(name)
    redirect '/catalogues'
  end

  get '/stylesheets/style.css' do
    sass :style
  end

  get '/:name' do
    haml :catalogue_show
  end

end