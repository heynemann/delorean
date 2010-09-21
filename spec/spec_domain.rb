# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

$LOAD_PATH << '../src'

require 'domain'

describe Catalogue do
  before(:each) do
    @catalogue = Catalogue.new("test")
  end

  it "should have the right name" do
    @catalogue.name.should == "test"
  end

end
