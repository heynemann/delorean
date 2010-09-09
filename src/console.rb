#!/usr/bin/env ruby -w
require "rubygems" 
require "simpleconsole" 
# require File.dirname(__FILE__) + "/../" 

class Controller < SimpleConsole::Controller
  def default
    load "server"
  end
end

class View < SimpleConsole::View
  def default
    
  end
end

SimpleConsole::Application.run(ARGV, Controller, View)
