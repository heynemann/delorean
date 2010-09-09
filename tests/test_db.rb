$LOAD_PATH << '../src'
require 'db'

describe Db, "start" do
  it "initializes a new values dictionary" do
    db = Db.new
    db.values == {}
  end
end

