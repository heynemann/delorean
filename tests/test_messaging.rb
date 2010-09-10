$LOAD_PATH << '../src'

require 'messaging'

describe CreateCatalogueMessage do
  before(:each) do
    @set = MessageSet.new
  end
  
  it "should process the message to include itself to the catalogues list" do
    message = CreateCatalogueMessage.new "uri"=>"/:new", "name" => "my_catalogue"
    message.process @set.catalogues
    
    @set.catalogues["my_catalogue"].should == { "name"=>"my_catalogue" }
  end
  
end

describe MessageSet do
  before(:each) do
    @set = MessageSet.new
  end

  it "should initialize with a messages array empty" do
    @set.messages.should == []
  end

  it "should load a file with proper messages" do
    @set.load('proper_messages_1.txt')

    @set.messages.count.should == 1
    @set.messages[0].class.should == CreateDocumentMessage
    @set.messages[0].type.should == "create"
    @set.messages[0].uri.should == "/test/:new"
    @set.messages[0].message.should == {"name" => "some random message"}
  end

  it "should load all messages" do
    @set.load_all('./load_all_tests')

    @set.messages.count.should == 2
    @set.messages[0].message.should == {"name" => "Bernardo1"}
    @set.messages[0].uri.should == "/test/1"
    @set.messages[1].message.should == {"name" => "Bernardo2"}
    @set.messages[1].uri.should == "/test/2"
  end
  
  it "should serialize and deserialize messages to proper files" do
    @set.messages << CreateCatalogueMessage.new("name" => "my_catalogue")
    @set.messages << CreateDocumentMessage.new("uri" => "/my_catalogue/user/:new", 
                                               "document" => {"name" => "Bernardo"})
    @set.messages << DeleteDocumentMessage.new("uri" => "/my_catalogue/user/1")

    @set.is_dirty?.should == true
    @set.dirty_messages.count.should == 3

    @set.persist!('serialize_deserialize_test.txt')

    new_set = MessageSet.new
    new_set.load('serialize_deserialize_test.txt')

    new_set.messages.count.should == 3
    new_set.is_dirty?.should == false
    new_set.dirty_messages.count.should == 0

  end
  
  it "should post a message and add it to dirty messages" do
    @set.post CreateCatalogueMessage.new "name" => "my_catalogue"
    
    @set.catalogues.keys.should == ["my_catalogue"]
  end
end
