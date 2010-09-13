$LOAD_PATH << '../src'
require 'db'

describe Db do

  before(:each) do
    @db = Db.new
  end
  
  it "initializes a new catalogues dictionary" do
    @db.catalogues.should == {}
  end

  it "should create a new catalogue" do
    @db.create_catalogue("my_catalogue")

    @db.catalogues.keys.should == ['my_catalogue']
  end

end
