require File.expand_path( File.join( File.dirname(__FILE__), "../helper" ) )
require "smith/world"

describe Smith::World do
  it "can be instantiated" do
    world = Smith::World.new
    world.should_not eq( nil )
  end
end