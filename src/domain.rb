# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

class Catalogue
  attr_reader :name, :documents

  def initialize(name)
    @name = name
    @documents = []
  end
end