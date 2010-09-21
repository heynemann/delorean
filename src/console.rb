#!/usr/bin/env ruby -w
require "rubygems"
require "simpleconsole"
require "sinatra"
require "server"

#Controller that responds for the console.
class Controller < SimpleConsole::Controller
  def default
    Server.run!
  end
end

#View that responds for the console
class View < SimpleConsole::View
  def default

  end
end

SimpleConsole::Application.run(ARGV, Controller, View)
