# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

class Catalogue
  attr_reader :name, :documents

  def initialize(name)
    @name = name
    @documents = {}
  end

  def last_message_date
    return nil if @documents.count == 0

    return @documents.values.last.timestamp
  end

  def to_dict
    {
      'name' => @name,
      'documentCount' => @documents.count,
      'lastMessageDate' => last_message_date
    }
  end
end

class Document
  attr_reader :uri, :id, :timestamp, :body
  def initialize(uri, id, timestamp, body)
    @uri = uri
    @id = id
    @timestamp = timestamp
    @body = body
  end

  def to_dict
    {
      'uri' => @uri,
      'id' => @id,
      'timestamp' => @timestamp,
      'body' => @body
    }
  end
end