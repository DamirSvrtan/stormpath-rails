require "spec_helper"
require 'mongoid'
require "stormpath-rails"

describe "Mongoid document" do
  class MongoidEntity
    include Mongoid::Document
    include Stormpath::Rails::Account
  end

  subject { MongoidEntity.new }

  before(:each) do
    # binding.pry
    Mongoid::Config.connect_to("stormpath_rails_test")
  end

  it_should_behave_like "stormpath account"

end
