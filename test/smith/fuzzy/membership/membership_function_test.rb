require File.expand_path( File.join( File.dirname(__FILE__), "../../../helper" ) )

require 'test/unit'
#require 'smith/constants'
require 'smith/fuzzy/membership/membership_function'

class MembershipFunctionTest < Test::Unit::TestCase

  def setup
    @no_f = Smith::Fuzzy::MembershipFunction.new
    
    @f = Smith::Fuzzy::MembershipFunction.new
    @f.add lambda {|v| 0.5 }, nil, (-Smith::INF..Smith::INF), nil
    
    @rand = Smith::Fuzzy::MembershipFunction.new
    @rand.add lambda {|x| rand(101)/100.0 }, nil, (-Smith::INF..Smith::INF), nil
    
    @square = Smith::Fuzzy::MembershipFunction.new
    @square.add lambda {|x| x*x }, lambda {|y| [-Math.sqrt(y),Math.sqrt(y)] },
                (-1..1), (0..1)
  end
  
  def test_creation_without_lambda
    assert_not_nil @no_f, "Was nil after created"
    assert_kind_of Smith::Fuzzy::MembershipFunction, @no_f, 
      "Object created was not a Smith::Fuzzy::MembershipFunction"
  end
  
  def test_nil_lambda_invocation_raises_exception
    assert_not_nil @no_f, "Was nil after created"
    assert_raise( Smith::Fuzzy::MembershipFunctionNotSetError ) do
      @no_f.call(0)
    end
  end
  
  def test_creation_with_lambda
    assert_not_nil @f, "Was nil after created"
    assert_kind_of Smith::Fuzzy::MembershipFunction, @f, 
      "Object created was not a Smith::Fuzzy::MembershipFunction"
  end
  
  def test_lamba_can_be_set
    @no_f.add lambda {|x| 0.5 }, nil, (-Smith::INF..Smith::INF), nil
    assert_equal 0.5, @no_f.call(0), "Lambda function should be callable"
  end

  def test_lambda_cannot_be_invoked_directly
    res = nil
    assert_raise( NoMethodError ) do
      res = @f.proc.call(100)
    end
    assert_nil res, "Result from call should be nil"
  end
  
  def test_call_returns_value_in_proper_range
    assert_operator @rand.call(0), :>=, 0.0, "Call should return value >= 0.0"
    assert_operator @rand.call(0), :<=, 1.0, "Call should return value <= 1.0"
    mf = Smith::Fuzzy::MembershipFunction.new
    mf.add lambda {|x| 100}, nil, (-Smith::INF..Smith::INF), nil
    assert_raise( Smith::Fuzzy::InvalidMembershipValueError ) do
      mf.call(0)
    end
  end
  
  def test_inverse_input_checking
    assert_raise( Smith::Fuzzy::InvalidMembershipValueError ) do
      @square.inverse( -0.5 )
    end
  end
end
