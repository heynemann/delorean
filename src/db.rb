require "json"

class Db
  attr_reader :values
  def initialize
    @values = {}
  end
end

class MessageLoader
  attr_reader :messages
  def initialize
    @messages = []
  end
  
  def load_all(folder)
    
  end

  def load(file)
    File.open(file, 'r') do |message_file|  
      while line = message_file.gets
        contents = JSON.parse(line)
        msg = FileSystemMessage.new :type => contents["type"], :message => nil
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