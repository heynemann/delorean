# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

require "json"
require "date"
require "Time"

require "domain"

class MessageSet
  attr_reader :messages, :catalogues, :dirty_messages
  def initialize(loader=FileSystemLoader)
    @loader = loader.new(self)
    @messages = []
    @catalogues = {}
    @dirty_messages = []
  end
  def is_dirty?
    @dirty_messages.count > 0
  end
  def load(file)
    @loader.load(file, @catalogues)
  end
  def load_all(folder)
    @loader.load_all(folder, @catalogues)
  end
  def post(message)
    return_value = message.process @catalogues
    @dirty_messages << message

    return_value
  end
  def persist!(folder, filename=nil)
    @loader.persist! folder, filename, @dirty_messages
    @dirty_messages.each { |message|
      @messages << message
    }
    @dirty_messages.clear
  end
end

#Base class for all loaders
class Loader
  def initialize(message_set)
    @message_set = message_set
    @message_types = {
      "create_catalogue" => CreateCatalogueMessage,
      "create_document" => CreateDocumentMessage,
      "delete_document" => DeleteDocumentMessage
    }
  end

  def load_all(folder, catalogues)
    nil
  end

  def load(file)
    nil
  end

  def match_for(contents)
    nil
  end

  def persist!(folder, filename)
    nil
  end

end

#Loads the db from the filesystem.
class FileSystemLoader < Loader
  def load_all(folder, catalogues)
    entries = Dir.new(folder).entries
    entries.sort.each do |entry|
      next if ['.', '..'].include?(entry)

      path = File.join(folder, entry)
      next unless File.exists? path
      load(path, catalogues)
    end
  end

  def load(file, catalogues)
    File.open(file, 'r') do |message_file|
      while line = message_file.gets
        contents = JSON.parse(line)
        msg = match_for contents, catalogues
        msg.process catalogues
        @message_set.messages << msg
      end
    end
  end

  def match_for(contents, catalogues)
    type = contents["type"]
    operation = contents["operation"]

    message_type = @message_types["#{type}_#{operation}"]

    if not message_type
      raise "Message Type with type #{type} and operation type #{operation} not found!"
    end

    if message_type != CreateCatalogueMessage
      contents["catalogues"] = catalogues
    end

    message_type.new(contents, contents["timestamp"])
  end

  def persist!(folder, filename, messages)
    filename = "messages_for_#{Date.today.to_s}.txt" unless filename

    open(File.join(folder, filename), 'a') { |messages_file|
      messages.each { |message|
        messages_file.puts message.to_message.to_json
      }
    }
  end
end

#Base class for all messages
class Message
  attr_reader :timestamp
  def initialize(timestamp=nil)
    @timestamp ||= Time.now
  end
end

#Base class for URI enabled messages
class URIOperationMessage < Message
  attr_reader :type, :operation, :uri
  def initialize(message_type, operation_type, arguments, timestamp=nil)
    super(timestamp)
    @type = message_type
    @operation = operation_type
    @uri = arguments["uri"]
  end
end

#Base class for URI enabled messages that have a message body and operation
class MessageEnabledURIOperationMessage < URIOperationMessage
  attr_reader :message
  def initialize(message_type, operation_type, message, arguments, timestamp=nil)
    super(message_type, operation_type, arguments, timestamp)
    @message = message
  end
end

#Creates catalogues
class CreateCatalogueMessage < MessageEnabledURIOperationMessage
  attr_reader :name
  def initialize(arguments, timestamp=nil)
    @name = arguments["document"]["name"]
    message = { "name" => @name }
    arguments["uri"] = "/#{@name}"
    super("create", "catalogue", message, arguments, timestamp)
  end

  def process(catalogues)
    catalogues[@name] = Catalogue.new @name
    catalogues[@name]
  end

  def to_message
    {
      "timestamp" => @timestamp,
      "type" => @type,
      "operation" => @operation,
      "uri" => @uri,
      "document" => @message
    }
  end
end

#Creates documents
class CreateDocumentMessage < MessageEnabledURIOperationMessage
  attr_reader :id

  def initialize(arguments, timestamp=nil)
    @catalogue_name = arguments["catalogue_name"]
    @id = arguments["id"]
    super("create", "document", arguments["document"], arguments, timestamp)
  end

  def process(catalogues)
    catalogue = catalogues[@catalogue_name]
    if not catalogue
      raise "Catalogue with name #{@catalogue_name} not found!"
    end
    document = Document.new(@uri, @id, @timestamp, @message)
    catalogue.documents << document

    document
  end

  def to_message
    {
      "catalogue_name" => @catalogue_name,
      "timestamp" => @timestamp,
      "type" => @type,
      "operation" => @operation,
      "uri" => @uri,
      "document" => @message
    }
  end
end

#Deletes documents
class DeleteDocumentMessage < URIOperationMessage
  def initialize(arguments, timestamp=nil)
    super("delete", "document", arguments, timestamp)
  end

  def process(catalogues)
    nil
  end
  def to_message
    {
      "timestamp" => @timestamp,
      "type" => @type,
      "operation" => @operation,
      "uri" => @uri
    }
  end
end
