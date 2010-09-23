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
    source = params[:source]
    if not name
      halt 500, "You can't create a catalogue without a name."
    end

    catalogue = settings.db.get_or_create_catalogue(name)

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
    if not settings.db.catalogues.has_key? params[:name]
      halt 404, "Catalogue with name #{params[:name]} not found!"
    end
    catalogue = settings.db.catalogues[params[:name]]
    source = params[:source]

    message_body = JSON.parse params[:message]
    message = settings.db.create_message(catalogue, message_body)

    if source == 'database'
      redirect "/#{params[:name]}"
    end

    message.to_dict.to_json
  end

  get '/:name/documents' do
    if not settings.db.catalogues.has_key? params[:name]
      halt 404, "Catalogue with name #{params[:name]} not found!"
    end

    json_documents = []

    settings.db.catalogues[params[:name]].documents.each do |document|
      json_documents << document.to_dict
    end

    json_documents.to_json
  end

  get '/:name/:document_id' do
    content_type 'application/json', :charset => 'utf-8'
    if not settings.db.catalogues.has_key? params[:name]
      halt 404, {:error => "Catalogue with name #{params[:name]} not found!"}.to_json
    end
    catalogue = settings.db.catalogues[params[:name]]

    if not catalogue.documents_by_id.has_key? params[:document_id]
      halt 404, {:error => "Document with id #{params[:document_id]} in catalogue #{params[:name]} not found!"}.to_json
    end
    document = catalogue.documents_by_id[params[:document_id]]
    document.to_dict.to_json
  end

  get '/:name' do
    if not settings.db.catalogues.has_key? params[:name]
      halt 404, "Catalogue with name #{params[:name]} not found!"
    end

    params['catalogue'] = settings.db.catalogues[params[:name]]
    haml :catalogue_show
  end

  get '/' do
    redirect '/about'
  end

end