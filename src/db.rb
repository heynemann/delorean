
class Db
  attr_reader :catalogue_loader
  def initialize
    @catalogue_loader = CatalogueLoader.new
  end
  
  def catalogues
    @catalogue_loader.catalogues
  end

  def create_catalogue(name)
    @catalogue_loader.create_catalogue(name)
  end
end

class CatalogueLoader
  attr_reader :messages
  attr_reader :catalogues
  def initialize
    @messages = []
    @catalogues = {
      
    }
  end

  def create_catalogue(name)
    message = NewCatalogueMessage.new :message => { :name => name }
    @messages << message

    @catalogues[name] = {
      :id => name,
      :messages => MessageLoader.new
    }
  end
end
