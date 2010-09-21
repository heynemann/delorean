# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

$LOAD_PATH << '../src'

require 'time'
require 'messaging'
require 'domain'

describe Catalogue do
  before(:each) do
    @catalogue = Catalogue.new("test")
  end

  it "should have the right name" do
    @catalogue.name.should == "test"
  end

  it "should return last message date as nil if no messages found" do
    @catalogue.last_message_date.should == nil
  end

  it "should return last message date" do
    expected_date = Time.local(2010, "sep", 21, 11, 33, 34)
    expected_arguments = { "document" => { "name" => "my_catalogue" } }
    message = CreateCatalogueMessage.new(expected_arguments, expected_date)
    @catalogue.documents << message
    @catalogue.last_message_date.should == expected_date
  end

end
