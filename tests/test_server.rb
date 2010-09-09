$LOAD_PATH << '../src'
require 'spec'
require 'rack/test'

require 'server'

set :environment, :test

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end

describe 'Delorean Server' do

  def app
    Server
  end

  it "should display the catalogues page listing all catalogues" do
    get '/catalogues'
    last_response.should be_ok
    last_response.body.include?('Catalogues')
    last_response.body.include?('Add new catalogue')
  end

  it "should show the about page" do
    get '/about'
    last_response.should be_ok
    last_response.body.include?("What's Delorean?")
    last_response.body.include?("Downloading the Source")
    last_response.body.include?("Suggestions")
  end

  it "should show the new catalogue page" do
    get '/catalogues/new'
    last_response.should be_ok
    last_response.body.include?('Name')
  end

end