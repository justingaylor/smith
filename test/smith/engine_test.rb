require File.expand_path( File.join( File.dirname(__FILE__), "../helper" ) )
require "smith/engine"

describe Smith::Engine do
  it "can be instantiated" do
    engine = Smith::Engine.new
    engine.should_not eq( nil )
  end
end