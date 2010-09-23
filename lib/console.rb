#!/usr/bin/env ruby -w
require "rubygems"
require "simpleconsole"

require "server"

#Controller that responds for the console.
class Controller < SimpleConsole::Controller
  params :string => { :u => :username, :p => :password, :d => :dir, :h => :host }
  params :int => { :t => :port }

  def default
    if not params[:username] or not params[:password]
      puts "You must specify username and password for the database instance via the --username and --password arguments."
      Process.exit! 1
    end

    dir = params[:dir] || "/tmp/db"
    host = params[:host] || "localhost"
    port = params[:port] || 4567

    Server.set_credentials(params[:username], params[:password])
    Server.set_folder(dir)

    Server.run! :host => host, :port => port
  end
end

#View that responds for the console
class View < SimpleConsole::View
  def default

  end
end

