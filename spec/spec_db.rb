$LOAD_PATH << '../src'

require 'fileutils'
require 'db'

describe Db do

  before(:each) do
    FileUtils.rm_rf '/tmp/test_db' if File.exists? '/tmp/test_db'
    @db = Db.new('/tmp/test_db')
  end

  it "initializes a new catalogues dictionary" do
    @db.catalogues.should == {}
  end

  it "should create a new catalogue" do
    @db.create_catalogue("my_catalogue")

    @db.catalogues.keys.should == ['my_catalogue']
  end

end
