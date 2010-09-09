require "json"

class Db
  attr_reader :catalogues
  def initialize
    @catalogues = {}
  end
end

class MessageLoader
  attr_reader :messages
  def initialize
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
        msg = FileSystemMessage.new :type => contents["type"], :message => contents
        @messages << msg
      end
    end
  end
end

class Message
  attr_reader :type, :message

  def initialize(arguments)
    @type = arguments[:type]
    @message = arguments[:message]
  end
end

class FileSystemMessage < Message

end

class NewCatalogueMessage < FileSystemMessage
  attr_reader :operation_type
  def initialize(arguments)
    @type = :create
    @operation_type = :catalogue
    @message = arguments[:message]
  end
end