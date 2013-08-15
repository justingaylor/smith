require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/set'
require 'smith/fuzzy/membership_function'

=begin

# Types of membership functions
UniformFunction
TriangularFunction
RampFunction
TrapezoidalFunction
SingletonFunction
GaussianFunction
SigmoidalFunction
SigmoidalDifferenceFunction
BellFunction
PiecewiseFunction


name = "cold"
function = Smith::Fuzzy::TriangularFunction.new
set = Smith::Fuzzy::Set.new( name, function )

=end

class SetTest < Test::Unit::TestCase
  def test_create
    set = Smith::Fuzzy::Set.new
    assert_not_nil set
  end
  
  def test_create_with_name
    set = Smith::Fuzzy::Set.new "cold"
    assert_not_nil set
    assert_equal "cold", set.name
  end
  
  def test_assign_name
    set = Smith::Fuzzy::Set.new
    assert_not_nil set
    set.name = "cold"
    assert_equal "cold", set.name
  end
  
  def test_create_with_function
    f = Smith::Fuzzy::MembershipFunction.new ( "test" )
    set = Smith::Fuzzy::Set.new "hot", f
    assert_not_nil set
    assert_equal "hot", set.name
    assert_not_nil set.f
  end
  
  
end