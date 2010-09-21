# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

class Catalogue
  attr_reader :name, :documents

  def initialize(name)
    @name = name
    @documents = []
  end

  def last_message_date
    return nil if @documents.count == 0

    return @documents.last.timestamp
  end
end

class Document
  attr_reader :uri, :timestamp, :body
  def initialize(uri, timestamp, body)
    @uri = uri
    @timestamp = timestamp
    @body = body
  end
end