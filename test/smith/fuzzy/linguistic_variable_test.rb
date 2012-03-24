require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/linguistic_variable'

class LinguisticVariableTest < Test::Unit::TestCase
  
  def test_creation
    lv = Smith::Fuzzy::LinguisticVariable.new("temperature")
    assert_not_nil lv, "Was nil after created"
    assert_kind_of Smith::Fuzzy::LinguisticVariable, lv, 
      "Object created was not a Smith::Fuzzy::LinguisticVariable"
  end

  def test_initialize_name
    name = "temperature"
    lv = Smith::Fuzzy::LinguisticVariable.new( name )
    assert_not_nil lv.name, "Name should not be nil"
    assert_equal lv.name, name, "Name does not match the value provided"
  end
  
  # Test that an exception is raised when no name is specified
  def test_name_required
    assert_raise( ArgumentError ) do 
      lv = Smith::Fuzzy::LinguisticVariable.new
    end
  end
  
  def test_cannot_set_name
    name = "pressure"
    lv = Smith::Fuzzy::LinguisticVariable.new("temperature")
    assert_raise( NoMethodError ) do
      lv.name = name
    end
    assert_not_equal lv.name, name, "Name should not match the value set"
  end
  
  def test_set_value
    val = 0.6
    lv = Smith::Fuzzy::LinguisticVariable.new("temperature")
    lv.val = val
    assert_not_nil lv.val, "Value should not be nil after setting"
    assert_equal lv.val, val, "Value does not match the value set"
  end
end
