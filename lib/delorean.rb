#!/usr/bin/env ruby

begin
  require_relative 'console'
rescue LoadError
  require 'rubygems'
  require_relative 'console'
end

SimpleConsole::Application.run(ARGV, Controller, View)
