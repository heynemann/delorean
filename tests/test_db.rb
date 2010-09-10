$LOAD_PATH << '../src'
require 'db'

describe Db do

  it "initializes a new catalogues dictionary" do
    db = Db.new
    db.catalogues.should == {}
  end

end
