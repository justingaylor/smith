require File.expand_path( File.join( File.dirname(__FILE__), "../../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/membership/triangular_function'

class TriangularFunctionTest < Test::Unit::TestCase
  
  def test_create_name_required
    assert_raise( ArgumentError ) do
      peak = Smith::Fuzzy::TriangularMembershipFunction.new
    end
  end
  
  def test_create_slope_required
    assert_raise( ArgumentError ) do
      peak = Smith::Fuzzy::TriangularMembershipFunction.new
    end
  end
  
  def test_create_peak_x_required
    assert_raise( ArgumentError ) do
      peak = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0 )
    end
  end
  
  def test_creation
    peak = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, 0.0 )
    assert_not_nil peak, "Object should not be nil after creation"
    assert_kind_of Smith::Fuzzy::TriangularMembershipFunction, peak, 
      "Object should be of type Smith::Fuzzy::TriangularMembershipFunction"
  end
  
  def test_accepts_fixnum_properly
    peak = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, 0.0 )
    message = "Value not in expected delta"
    assert ((peak.call(0) - 1.0).abs <= Smith::DELTA), message
    assert ((peak.call(1) - 0.0).abs <= Smith::DELTA), message
    assert ((peak.call(-1) - 0.0).abs <= Smith::DELTA), message
  end
  
  def test_functional_correctness_at_origin
    message = "Value not in expected delta"
    peak = 0.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, peak )
    assert_in_delta 1.0, f.call(0.0+peak), Smith::DELTA, message
    assert_in_delta 0.0, f.call(1.0+peak), Smith::DELTA, message
    assert_in_delta 0.0, f.call(-1.0+peak), Smith::DELTA, message
    assert_in_delta 0.8, f.call((1.0/5.0)+peak), Smith::DELTA, message
    assert_in_delta 0.8, f.call((-1.0/5.0)+peak), Smith::DELTA, message
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

  def test_functional_correctness_shifted_positive
    message = "Value not in expected delta"
    peak = 5.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, peak )
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
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, peak )
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
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 2.0, peak )
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
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 0.5, peak )
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
  
end
