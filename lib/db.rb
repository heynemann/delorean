require 'Time'

require 'messaging'
require 'uuid'

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
    if @message_set.catalogues.has_key? name
      return @message_set.catalogues[name]
    else
      message = CreateCatalogueMessage.new "document" => {"name" => name}
      return_value = @message_set.post message
      persist!
      return_value
    end
  end

  def create_message(catalogue, message)
    document_id = UUID.create.to_s.slice(0..7)
    while catalogue.documents_by_id.has_key? document_id
      document_id = UUID.create.to_s.slice(0..7)
    end
    uri = "/#{catalogue.name}/#{document_id}"
    arguments = {
                  "document" => message,
                  "catalogue_name" => catalogue.name,
                  "uri" => uri,
                  "id" => document_id
                }
    message = CreateDocumentMessage.new arguments, Time.now
    return_value = @message_set.post message
    persist!
    return_value
  end
end

