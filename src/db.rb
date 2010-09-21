require 'messaging'
require 'Time'

#class that represents the Database.
class Db
  attr_reader :catalogue_loader
  def initialize(messages_path='/tmp/db')
    @messages_path = messages_path
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

  def create_message(catalogue, message)
    document_index = catalogue.documents.count
    uri = "/#{catalogue.name}/#{document_index}"
    arguments = { "document" => message,
                  "catalogue_name" => catalogue.name,
                  "uri" => uri
                }
    message = CreateDocumentMessage.new arguments, Time.now
    @message_set.post message
    persist!
  end
end

