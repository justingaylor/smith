require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/triangular_membership_function'

class TriangularMembershipFunctionTest < Test::Unit::TestCase
  
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
    delta = 0.000000000000001
    assert ((peak.call(0) - 1.0).abs <= delta), message
    assert ((peak.call(1) - 0.0).abs <= delta), message
    assert ((peak.call(-1) - 0.0).abs <= delta), message
  end
  
  def test_functional_correctness_at_origin
    message = "Value not in expected delta"
    delta = 0.000000000000001
    peak = 0.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, peak )
    assert ((f.call(0.0+peak) - 1.0).abs <= delta), message
    assert ((f.call(1.0+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.0+peak) - 0.0).abs <= delta), message
    assert ((f.call((1.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((-1.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((1.0/3.0)+peak) - (2.0/3.0)).abs <= delta), message
    assert ((f.call((-1.0/3.0)+peak) - (2.0/3.0)).abs <= delta), message
    assert ((f.call(0.5+peak) - 0.5).abs <= delta), message
    assert ((f.call(-0.5+peak) - 0.5).abs <= delta), message
    assert ((f.call((4.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call((-4.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call(1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(100+peak) - 0.0).abs <= delta), message
    assert ((f.call(-100+peak) - 0.0).abs <= delta), message
  end

  def test_functional_correctness_shifted_positive
    message = "Value not in expected delta"
    delta = 0.000000000000001
    peak = 5.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, peak )
    assert ((f.call(0.0+peak) - 1.0).abs <= delta), message
    assert ((f.call(1.0+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.0+peak) - 0.0).abs <= delta), message
    assert ((f.call((1.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((-1.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((1.0/3.0)+peak) - (2.0/3.0)).abs <= delta), message
    assert ((f.call((-1.0/3.0)+peak) - (2.0/3.0)).abs <= delta), message
    assert ((f.call(0.5+peak) - 0.5).abs <= delta), message
    assert ((f.call(-0.5+peak) - 0.5).abs <= delta), message
    assert ((f.call((4.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call((-4.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call(1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(100+peak) - 0.0).abs <= delta), message
    assert ((f.call(-100+peak) - 0.0).abs <= delta), message
  end
  
  def test_functional_correctness_shifted_negative
    message = "Value not in expected delta"
    delta = 0.000000000000001
    peak = -5.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 1.0, peak )
    assert ((f.call(0.0+peak) - 1.0).abs <= delta), message
    assert ((f.call(1.0+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.0+peak) - 0.0).abs <= delta), message
    assert ((f.call((1.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((-1.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((1.0/3.0)+peak) - (2.0/3.0)).abs <= delta), message
    assert ((f.call((-1.0/3.0)+peak) - (2.0/3.0)).abs <= delta), message
    assert ((f.call(0.5+peak) - 0.5).abs <= delta), message
    assert ((f.call(-0.5+peak) - 0.5).abs <= delta), message
    assert ((f.call((4.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call((-4.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call(1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(100+peak) - 0.0).abs <= delta), message
    assert ((f.call(-100+peak) - 0.0).abs <= delta), message
  end
  
  def test_functional_correctness_narrowed
    message = "Value not in expected delta"
    delta = 0.000000000000001
    peak = 0.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 2.0, peak )
    assert ((f.call(0.0+peak) - 1.0).abs <= delta), message
    assert ((f.call(0.5+peak) - 0.0).abs <= delta), message
    assert ((f.call(-0.5+peak) - 0.0).abs <= delta), message
    assert ((f.call((1.0/5.0)+peak) - 0.6).abs <= delta), message
    assert ((f.call((-1.0/5.0)+peak) - 0.6).abs <= delta), message
    assert ((f.call(0.25+peak) - 0.5).abs <= delta), message
    assert ((f.call(-0.25+peak) - 0.5).abs <= delta), message
    assert ((f.call((2.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call((-2.0/5.0)+peak) - 0.2).abs <= delta), message
    assert ((f.call(1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(-1.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(100+peak) - 0.0).abs <= delta), message
    assert ((f.call(-100+peak) - 0.0).abs <= delta), message
  end
  
  def test_functional_correctness_widened
    message = "Value not in expected delta"
    delta = 0.000000000000001
    peak = 0.0
    f = Smith::Fuzzy::TriangularMembershipFunction.new( 0.5, peak )
    assert ((f.call(0.0+peak) - 1.0).abs <= delta), message
    assert ((f.call(2.0+peak) - 0.0).abs <= delta), message
    assert ((f.call(-2.0+peak) - 0.0).abs <= delta), message
    assert ((f.call((1.0/5.0)+peak) - 0.9).abs <= delta), message
    assert ((f.call((-1.0/5.0)+peak) - 0.9).abs <= delta), message
    assert ((f.call(1.0+peak) - 0.5).abs <= delta), message
    assert ((f.call(-1.0+peak) - 0.5).abs <= delta), message
    assert ((f.call((2.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call((-2.0/5.0)+peak) - 0.8).abs <= delta), message
    assert ((f.call(2.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(-2.01+peak) - 0.0).abs <= delta), message
    assert ((f.call(100+peak) - 0.0).abs <= delta), message
    assert ((f.call(-100+peak) - 0.0).abs <= delta), message
  end
  
end