require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/membership_function'

class MembershipFunctionTest < Test::Unit::TestCase
  def test_creation_without_lambda
	  mf = Smith::Fuzzy::MembershipFunction.new( "no_lambda" )
	  assert_not_nil mf, "Was nil after created"
	  assert_kind_of Smith::Fuzzy::MembershipFunction, mf, 
	    "Object created was not a Smith::Fuzzy::MembershipFunction"
  end
  
  def test_nil_lambda_invocation_raises_exception
	  mf = Smith::Fuzzy::MembershipFunction.new( "no_lambda" )
	  assert_not_nil mf, "Was nil after created"
	  assert_raise( Smith::Fuzzy::MembershipFunctionNotSetError ) do
	    mf.call(0)
    end
  end
  
  def test_creation_with_lambda
    mf = Smith::Fuzzy::MembershipFunction.new( "50_perc", lambda {|v| 0.5 } )
	  assert_not_nil mf, "Was nil after created"
	  assert_kind_of Smith::Fuzzy::MembershipFunction, mf, 
	    "Object created was not a Smith::Fuzzy::MembershipFunction"
  end
  
  def test_lamba_can_be_set
    mf = Smith::Fuzzy::MembershipFunction.new( "50_perc" )
	  mf.f = lambda {|v| 0.5 }
	  assert_equal mf.call(0), 0.5, "Lambda function should be callable"
  end
  
  def test_lambda_cannot_be_invoked_directly
    mf = Smith::Fuzzy::MembershipFunction.new( "50_perc" )
	  mf.f = lambda {|v| 0.5 }
	  res = nil
	  assert_raise( NoMethodError ) do
	    res = mf.f.call(100)
	  end
	  assert_nil res, "Result from call should be nil"
  end
  
  def test_call_returns_value_in_proper_range
    mf = Smith::Fuzzy::MembershipFunction.new( "random", 
                                               lambda {|v| rand(101)/100.0 } )
	  assert_operator mf.call(0), :>=, 0.0, "Call should return value >= 0.0"
	  assert_operator mf.call(0), :<=, 1.0, "Call should return value <= 1.0"
	  mf = Smith::Fuzzy::MembershipFunction.new( "100_perc", lambda {|v| 100} )
	  assert_raise( Smith::Fuzzy::InvalidMembershipValueError ) do
	    mf.call(0)
	  end
  end

  def test_creation_with_name
    mf = Smith::Fuzzy::MembershipFunction.new( "50_perc", lambda {|v| 0.5 } )
    assert_equal mf.name, "50_perc", 
      "Name does not match value set in constructor"
  end
  
  def test_name_can_be_set
    mf = Smith::Fuzzy::MembershipFunction.new( "50_perc", lambda {|v| 0.5 } )
    mf.name = "50_percent"
    assert_equal mf.name, "50_percent"
  end
end
