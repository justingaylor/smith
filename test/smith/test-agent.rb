require File.expand_path( File.join( File.dirname(__FILE__), "../test-helper" ) )
require "smith/agent"

describe Smith::Agent do
  it "can be instantiated" do
    smith = Smith::Agent.new
    smith.should_not eq( nil )
  end
end


