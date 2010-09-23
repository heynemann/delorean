# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

require 'sinatra/base'
require 'haml'
require 'sass'

require 'authorization'
require 'db'

class Server < Sinatra::Base
  set :sessions, true
  set :public, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/views'

  helpers do
    include Sinatra::Authorization
  end

  def self.set_credentials(username, password)
    set :username, username
    set :password, password
  end

  def self.set_folder(dir)
    set :db, Db.new(dir)
  end

  def do_auth
    require_administrative_privileges(settings.username, settings.password)
  end

  before do
    content_type 'text/html', :charset => 'utf-8'
    do_auth
  end

  get '/logout' do
    logout
    redirect '/'
  end

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

    if settings.db.catalogue.has_key? name
      return settings.db.catalogue[name].to_dict.to_json
    end

    source = params[:source]
    if not name
      halt 500, "You can't create a catalogue without a name."
    end
    catalogue = settings.db.create_catalogue(name)

    if source == 'database'
      redirect '/catalogues'
    end

    catalogue.to_dict.to_json
  end

  get '/stylesheets/style.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :style
  end

  post '/:name/new' do
    catalogue = settings.db.catalogues[params[:name]]

    message = JSON.parse params[:message]
    settings.db.create_message(catalogue, message)
    redirect "/#{params[:name]}"
  end

  get '/:name' do
    params['catalogue'] = settings.db.catalogues[params[:name]]
    haml :catalogue_show
  end

  get '/' do
    redirect '/about'
  end

end