#!/usr/bin/env ruby -w
require "rubygems" 
require "simpleconsole" 
require "sinatra"
require "server"
# require File.dirname(__FILE__) + "/../" 

class Controller < SimpleConsole::Controller
  def default
    Server.run!
  end
end

class View < SimpleConsole::View
  def default
    
  end
end

SimpleConsole::Application.run(ARGV, Controller, View)
