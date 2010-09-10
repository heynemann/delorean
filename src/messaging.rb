require "json"

class MessageSet
  attr_reader :messages
  def initialize
    @message_types = {
      "create_catalogue" => CreateCatalogueMessage,
      "create_document" => CreateDocumentMessage,
      "delete_document" => DeleteDocumentMessage
    }
    @messages = []
  end
  
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
        @messages << msg
      end
    end
  end

  def match_for(contents)
    type = contents["type"]
    operation = contents["operation"]

    message_type = @message_types["#{type}_#{operation}"]
    message_type.new(contents)
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
  def initialize(arguments)
    message = { "name" => arguments["name"] }
    super("create", "catalogue", message, arguments)
  end
end

class CreateDocumentMessage < MessageEnabledURIOperationMessage
  def initialize(arguments)
    message = arguments["document"]
    super("create", "document", message, arguments)
  end
end

class DeleteDocumentMessage < URIOperationMessage
  def initialize(arguments)
    super("delete", "document", arguments)
  end
end