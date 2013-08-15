require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/trapezoidal_membership_function'

class TrapezoidalMembershipFunctionTest < Test::Unit::TestCase
  
  def test_create_name_too_few_parameters
    assert_raise( ArgumentError ) do
      peak = Smith::Fuzzy::TrapezoidalMembershipFunction.new
    end
  end
  
  def test_creation
    f = Smith::Fuzzy::TrapezoidalMembershipFunction.new("small", 0.0, 4.0, 20)
    assert_not_nil f, "Object should not be nil after creation"
    assert_kind_of Smith::Fuzzy::TrapezoidalMembershipFunction, f, 
      "Object should be of type Smith::Fuzzy::TrapezoidalMembershipFunction"
  end

  def test_accepts_fixnum_properly
    f = Smith::Fuzzy::TrapezoidalMembershipFunction.new("small", 0.0, 4.0, 20)
    message = "Value not in expected delta"
    assert_in_delta 1.0, f.call(0), DELTA, message
    assert_in_delta 0.0, f.call(-10), DELTA, message
    assert_in_delta 0.0, f.call(10), DELTA, message
  end
  
  def test_functional_correctness_at_origin
    message = "Value not in expected delta"
    x_center = 0.0
    width_peak = 4.0
    width_total = 10.0
    f = Smith::Fuzzy::TrapezoidalMembershipFunction.new( "small", 
                                                         x_center, 
                                                         width_peak, 
                                                         width_total )
    assert_in_delta 1.0, f.call(0.0+x_center), DELTA, message
    assert_in_delta 1.0, f.call(2.0+x_center), DELTA, message
    assert_in_delta 1.0, f.call(-2.0+x_center), DELTA, message
    assert_in_delta (2.0/3.0), f.call(3.0+x_center), DELTA, message
    assert_in_delta (2.0/3.0), f.call(-3.0+x_center), DELTA, message
    assert_in_delta 0.25, f.call(4.25+x_center), DELTA, message
    assert_in_delta 0.25, f.call(-4.25+x_center), DELTA, message
    assert_in_delta 0.0, f.call(5.0+x_center), DELTA, message
    assert_in_delta 0.0, f.call(-5.0+x_center), DELTA, message
    assert_in_delta 0.0, f.call(5.01+x_center), DELTA, message
    assert_in_delta 0.0, f.call(-5.01+x_center), DELTA, message
    assert_in_delta 0.0, f.call(100+x_center), DELTA, message
    assert_in_delta 0.0, f.call(-100+x_center), DELTA, message
  end
  
=begin
  def test_functional_correctness_shifted_positive
    message = "Value not in expected delta"
    peak = 5.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( "positive", 1.0, peak )
    assert_in_delta 1.0, f.call(0.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(1.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(-1.0+peak), DELTA, message
    assert_in_delta 0.8, f.call((1.0/5.0)+peak), DELTA, message
    assert_in_delta 0.8, f.call((-1.0/5.0)+peak), DELTA, message
    assert_in_delta (2.0/3.0), f.call((1.0/3.0)+peak), DELTA, message
    assert_in_delta (2.0/3.0), f.call((-1.0/3.0)+peak), DELTA, message
    assert_in_delta 0.5, f.call(0.5+peak), DELTA, message
    assert_in_delta 0.5, f.call(-0.5+peak), DELTA, message
    assert_in_delta 0.2, f.call((4.0/5.0)+peak), DELTA, message
    assert_in_delta 0.2, f.call((-4.0/5.0)+peak), DELTA, message
    assert_in_delta 0.0, f.call(1.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(-1.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(100+peak), DELTA, message
    assert_in_delta 0.0, f.call(-100+peak), DELTA, message
  end
  
  def test_functional_correctness_shifted_negative
    message = "Value not in expected delta"
    peak = -5.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( "negative", 1.0, peak )
    assert_in_delta 1.0, f.call(0.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(1.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(-1.0+peak), DELTA, message
    assert_in_delta 0.8, f.call((1.0/5.0)+peak), DELTA, message
    assert_in_delta 0.8, f.call((-1.0/5.0)+peak), DELTA, message
    assert_in_delta (2.0/3.0), f.call((1.0/3.0)+peak), DELTA, message
    assert_in_delta (2.0/3.0), f.call((-1.0/3.0)+peak), DELTA, message
    assert_in_delta 0.5, f.call(0.5+peak), DELTA, message
    assert_in_delta 0.5, f.call(-0.5+peak), DELTA, message
    assert_in_delta 0.2, f.call((4.0/5.0)+peak), DELTA, message
    assert_in_delta 0.2, f.call((-4.0/5.0)+peak), DELTA, message
    assert_in_delta 0.0, f.call(1.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(-1.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(100+peak), DELTA, message
    assert_in_delta 0.0, f.call(-100+peak), DELTA, message
  end
  
  def test_functional_correctness_narrowed
    message = "Value not in expected delta"
    peak = 0.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( "narrow", 2.0, peak )
    assert_in_delta 1.0, f.call(0.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(0.5+peak), DELTA, message
    assert_in_delta 0.0, f.call(-0.5+peak), DELTA, message
    assert_in_delta 0.6, f.call((1.0/5.0)+peak), DELTA, message
    assert_in_delta 0.6, f.call((-1.0/5.0)+peak), DELTA, message
    assert_in_delta 0.5, f.call(0.25+peak), DELTA, message
    assert_in_delta 0.5, f.call(-0.25+peak), DELTA, message
    assert_in_delta 0.2, f.call((2.0/5.0)+peak), DELTA, message
    assert_in_delta 0.2, f.call((-2.0/5.0)+peak), DELTA, message
    assert_in_delta 0.0, f.call(1.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(-1.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(100+peak), DELTA, message
    assert_in_delta 0.0, f.call(-100+peak), DELTA, message
  end
  
  def test_functional_correctness_widened
    message = "Value not in expected delta"
    peak = 0.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( "wide", 0.5, peak )
    assert_in_delta 1.0, f.call(0.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(2.0+peak), DELTA, message
    assert_in_delta 0.0, f.call(-2.0+peak), DELTA, message
    assert_in_delta 0.9, f.call((1.0/5.0)+peak), DELTA, message
    assert_in_delta 0.9, f.call((-1.0/5.0)+peak), DELTA, message
    assert_in_delta 0.5, f.call(1.0+peak), DELTA, message
    assert_in_delta 0.5, f.call(-1.0+peak), DELTA, message
    assert_in_delta 0.8, f.call((2.0/5.0)+peak), DELTA, message
    assert_in_delta 0.8, f.call((-2.0/5.0)+peak), DELTA, message
    assert_in_delta 0.0, f.call(2.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(-2.01+peak), DELTA, message
    assert_in_delta 0.0, f.call(100+peak), DELTA, message
    assert_in_delta 0.0, f.call(-100+peak), DELTA, message
  end
=end
end
