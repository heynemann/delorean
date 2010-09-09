require 'db'

require 'sinatra/base'

class Server < Sinatra::Base
  set :sessions, true
  set :db, Db.new

  get '/catalogues' do
    @catalogues = settings.db.catalogues
    haml :catalogue_list
  end
end