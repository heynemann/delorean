$LOAD_PATH << '../src'

require 'ftools'
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
    tmp_file = '/tmp/serialize_deserialize_test.txt'

    File.delete(tmp_file) if File.exists? tmp_file

    @set.post CreateCatalogueMessage.new("name" => "my_catalogue")
    @set.post CreateDocumentMessage.new("uri" => "/my_catalogue/user/:new",
                                        "document" => {"name" => "Bernardo"})
    @set.post DeleteDocumentMessage.new("uri" => "/my_catalogue/user/1")

    @set.is_dirty?.should == true
    @set.dirty_messages.count.should == 3

    @set.persist! tmp_file

    new_set = MessageSet.new
    new_set.load tmp_file

    new_set.messages.count.should == 3
    new_set.is_dirty?.should == false
    new_set.dirty_messages.count.should == 0
  end

  it "should post a message and add it to dirty messages" do
    @set.post CreateCatalogueMessage.new "name" => "my_catalogue"

    @set.catalogues.keys.should == ["my_catalogue"]
  end

  it "should check if the set is dirty" do
    @set.post CreateCatalogueMessage.new "name" => "my_catalogue"

    @set.is_dirty?.should == true
  end

  it "should persist the messages" do
    tmp_file = "/tmp/persist_test.txt"

    File.delete(tmp_file) if File.exists? tmp_file

    @set.post CreateCatalogueMessage.new "name" => "my_catalogue"

    @set.persist! tmp_file

    File.exists?(tmp_file).should == true

    new_set = MessageSet.new
    new_set.load tmp_file

    new_set.messages.count.should == 1
    new_set.messages[0].class == CreateCatalogueMessage
    new_set.messages[0].name == "my_catalogue"
    new_set.messages[0].uri == "/my_catalogue"
  end
end
