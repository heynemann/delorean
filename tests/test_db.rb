$LOAD_PATH << '../src'
require 'db'

describe Db do

  it "initializes a new values dictionary" do
    db = Db.new
    db.values == {}
  end

end

describe Message do
  
  it "should create a new message" do
    msg = Message.new
    msg
  end
  
end