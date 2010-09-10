require "json"

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
    @loader.load(file)
  end
  def load_all(folder)
    @loader.load_all(folder)
  end
  def post(message)
    message.process @catalogues
    @dirty_messages << message
  end
  def persist!(filename=nil)
    @loader.persist! filename, @dirty_messages
    @dirty_messages.each { |message|
      @messages << message
    }
    @dirty_messages.clear
  end
end

class Loader
  def initialize(message_set)
    @message_set = message_set
    @message_types = {
      "create_catalogue" => CreateCatalogueMessage,
      "create_document" => CreateDocumentMessage,
      "delete_document" => DeleteDocumentMessage
    }
  end

  def load_all(folder)
    nil
  end

  def load(file)
    nil
  end

  def match_for(contents)
    nil
  end

  def persist!(filename)
    nil
  end

end

class FileSystemLoader < Loader
  def load_all(folder)
    entries = Dir.new(folder).entries
    entries.sort.each do |entry|
      path = File.join(folder, entry)
      next if ['.', '..'].include?(entry)
      next unless File.exists? path
      load(path)
    end
  end

  def load(file)
    File.open(file, 'r') do |message_file|
      while line = message_file.gets
        contents = JSON.parse(line)
        msg = match_for contents
        @message_set.messages << msg
      end
    end
  end

  def match_for(contents)
    type = contents["type"]
    operation = contents["operation"]

    message_type = @message_types["#{type}_#{operation}"]
    message_type.new(contents)
  end

  def persist!(filename, messages)
    if not filename
      filename = "messages_for_#{Date.today.to_s}.txt"
    end

    open(filename, 'a') { |f|
      messages.each { |message|
        f.puts message.to_message.to_json
      }
    }
  end
end

class Message
end

class URIOperationMessage < Message
  attr_reader :type, :operation, :uri
  def initialize(message_type, operation_type, arguments)
    @type = message_type
    @operation = operation_type
    @uri = arguments["uri"]
  end
end

class MessageEnabledURIOperationMessage < URIOperationMessage
  attr_reader :message
  def initialize(message_type, operation_type, message, arguments)
    super(message_type, operation_type, arguments)
    @message = message
  end
end

class CreateCatalogueMessage < MessageEnabledURIOperationMessage
  attr_reader :name
  def initialize(arguments)
    @name = arguments["name"]
    message = { "name" => arguments["name"] }
    arguments["uri"] = '/catalogues/:new'
    super("create", "catalogue", message, arguments)
  end

  def process(catalogues)
    catalogues[@name] = @message
  end

  def to_message
    {
      "type" => @type,
      "operation" => @operation,
      "uri" => @uri,
      "document" => @message
    }
  end
end

class CreateDocumentMessage < MessageEnabledURIOperationMessage
  def initialize(arguments)
    message = arguments["document"]
    super("create", "document", message, arguments)
  end

  def process(catalogues)
    nil
  end

  def to_message

  end
end

class DeleteDocumentMessage < URIOperationMessage
  def initialize(arguments)
    super("delete", "document", arguments)
  end

  def process(catalogues)
    nil
  end
  def to_message

  end
end