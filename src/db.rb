require 'messaging'

class Db
  attr_reader :catalogue_loader
  def initialize
    @messages_path = '/tmp/db'
    Dir.mkdir(@messages_path) unless File.directory?(@messages_path)
    @message_set = MessageSet.new
    @message_set.load_all(@messages_path)
  end

  def catalogues
    @message_set.catalogues
  end

  def persist!()
    @message_set.persist! @messages_path
  end

  def create_catalogue(name)
    message = CreateCatalogueMessage.new "document" => {"name" => name}
    @message_set.post message
    persist!
  end
end

