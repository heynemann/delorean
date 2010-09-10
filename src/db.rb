require 'messaging'

class Db
  attr_reader :catalogue_loader
  def initialize
    @message_set = MessageSet.new
  end
  
  def catalogues
    @message_set.catalogues
  end

  def create_catalogue(name)
    message = CreateCatalogueMessage.new "name" => name
    @message_set.post message
  end
end

