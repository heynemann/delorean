$LOAD_PATH << '../src'
require 'db'

describe Db do

  it "initializes a new catalogues dictionary" do
    db = Db.new
    db.catalogues.should == {}
  end

end

describe Message do

  it "should create a new message" do
    msg = Message.new :type => :create, :message => { :name => "test" }
    msg

    msg.type.should == :create
    msg.message[:name].should == "test"
  end

end

describe FileSystemMessage do
  it "should create a new message" do
    msg = FileSystemMessage.new :type => :create, :message => { :name => "test" }
    msg

    msg.type.should == :create
    msg.message[:name].should == "test"
  end
end

describe NewCatalogueMessage do
  it "should create a new catalogue message" do
    msg = NewCatalogueMessage.new :message => { "name" => "my_catalogue" }

    msg

    msg.type.should == :create
    msg.operation_type.should == :catalogue
    msg.message == { "name" => "my_catalogue" }
  end
end

describe MessageLoader do
  before(:each) do
    @loader = MessageLoader.new
  end

  it "should initialize with a messages array empty" do
    @loader.messages.should == []
  end

  it "should load a file with proper messages" do
    @loader.load('proper_messages_1.txt')

    @loader.messages.count.should == 1
    @loader.messages[0].class.should == FileSystemMessage
    @loader.messages[0].type.should == "Create"
    @loader.messages[0].message.should == {"type" => "Create", "id" => "/test/1", "name" => "some random message"}
  end

  it "should load all messages" do
    @loader.load_all('./load_all_tests')

    @loader.messages.count.should == 2
    @loader.messages[0].message.should == {"type" => "Create", "id" => "/test/1", "name" => "Bernardo1"}
    @loader.messages[1].message.should == {"type" => "Create", "id" => "/test/2", "name" => "Bernardo2"}
  end
end