require File.expand_path( File.join( File.dirname(__FILE__), "../../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/membership/gaussian_function'

class GaussianFunctionTest < Test::Unit::TestCase

  def setup
    @gauss     = Smith::Fuzzy::GaussianFunction.new( 0.0, 1.0 )
    @shift_pos = Smith::Fuzzy::GaussianFunction.new( 2.0, 1.0 )
    @shift_neg = Smith::Fuzzy::GaussianFunction.new( -2.0, 1.0 )
    @widened   = Smith::Fuzzy::GaussianFunction.new( 0.0, 6.0 )
    @narrowed  = Smith::Fuzzy::GaussianFunction.new( 0.0, 0.5 )
  end
  
  def test_creation
    assert_not_nil @gauss, "Was nil after created"
    assert_kind_of Smith::Fuzzy::GaussianFunction, @gauss, 
      "Object created was not a Smith::Fuzzy::GaussianFunction, it " +
      "was a #{@gauss.class}"
  end
  
  def test_call_returns_value_in_proper_range
    assert_operator @gauss.call(0), :>=, 0.0, "Value returned should be >= 0.0"
    assert_operator @gauss.call(0), :<=, 1.0, "Value returned should be <= 1.0"
  end

  def test_call_correctness
    # Test simple case (zero-centered, width param is 1.0)
    assert_in_delta 1.0, @gauss.call( 0 ),  Smith::DELTA
    assert_in_delta 0.6065306597126334, @gauss.call( 1 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @gauss.call( -1 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @gauss.call( 2 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @gauss.call( -2 ), Smith::DELTA
    
    # Test positive shift case
    assert_in_delta 1.0, @shift_pos.call( 2 ),  Smith::DELTA
    assert_in_delta 0.6065306597126334, @shift_pos.call( 3 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @shift_pos.call( 1 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @shift_pos.call( 4 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @shift_pos.call( 0 ), Smith::DELTA
    
    # Test negative shift case
    assert_in_delta 1.0, @shift_neg.call( -2 ),  Smith::DELTA
    assert_in_delta 0.6065306597126334, @shift_neg.call( -1 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @shift_neg.call( -3 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @shift_neg.call( 0 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @shift_neg.call( -4 ), Smith::DELTA
    
    # Test widened case
    assert_in_delta 1.0, @widened.call( 0 ),  Smith::DELTA
    assert_in_delta 0.9862071167439163, @widened.call( 1 ), Smith::DELTA
    assert_in_delta 0.9862071167439163, @widened.call( -1 ), Smith::DELTA
    assert_in_delta 0.9459594689067655, @widened.call( 2 ), Smith::DELTA
    assert_in_delta 0.9459594689067655, @widened.call( -2 ), Smith::DELTA
    assert_in_delta 0.8007374029168081, @widened.call( 4 ), Smith::DELTA
    assert_in_delta 0.8007374029168081, @widened.call( -4 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @widened.call( 6 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @widened.call( -6 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @widened.call( 12 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @widened.call( -12 ), Smith::DELTA
    assert_in_delta 0.0, @widened.call( 1000 ), Smith::DELTA
    assert_in_delta 0.0, @widened.call( -1000 ), Smith::DELTA
    
    # Test narrowed case
    assert_in_delta 1.0, @narrowed.call( 0 ),  Smith::DELTA
    assert_in_delta 0.9801986733067553, @narrowed.call( 0.1 ), Smith::DELTA
    assert_in_delta 0.9801986733067553, @narrowed.call( -0.1 ), Smith::DELTA
    assert_in_delta 0.9231163463866358, @narrowed.call( 0.2 ), Smith::DELTA
    assert_in_delta 0.9231163463866358, @narrowed.call( -0.2 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @narrowed.call( 0.5 ), Smith::DELTA
    assert_in_delta 0.6065306597126334, @narrowed.call( -0.5 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @narrowed.call( 1.0 ), Smith::DELTA
    assert_in_delta 0.1353352832366127, @narrowed.call( -1.0 ), Smith::DELTA
    assert_in_delta 0.0003354626279025, @narrowed.call( 2.0 ), Smith::DELTA
    assert_in_delta 0.0003354626279025, @narrowed.call( -2.0 ), Smith::DELTA
    assert_in_delta 0.0, @narrowed.call( 10 ), Smith::DELTA
    assert_in_delta 0.0, @narrowed.call( -10 ), Smith::DELTA
  end
  
  def test_inverse_correctness
    # Test simple case (zero-centered, width param is 1.0)
    result = @gauss.inverse( 1 )
    assert_equal 1, result.size
    assert_not_nil result.index {|v| (v - 0).abs <= Smith::DELTA }
    result = @gauss.inverse( 0.6065306597126334 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 1).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 1).abs <= Smith::DELTA }
    result = @gauss.inverse( 0.1353352832366127 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 2).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 2).abs <= Smith::DELTA }

    # Test positive shift case
    result = @shift_pos.inverse( 1 )
    assert_equal 1, result.size
    assert_not_nil result.index {|v| (v - 2).abs <= Smith::DELTA }
    result = @shift_pos.inverse( 0.6065306597126334 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 1).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 3).abs <= Smith::DELTA }
    result = @shift_pos.inverse( 0.1353352832366127 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 4).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 0).abs <= Smith::DELTA }

    # Test negative shift case
    result = @shift_neg.inverse( 1 )
    assert_equal 1, result.size
    assert_not_nil result.index {|v| (v + 2).abs <= Smith::DELTA }
    result = @shift_neg.inverse( 0.6065306597126334 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 1).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 3).abs <= Smith::DELTA }
    result = @shift_neg.inverse( 0.1353352832366127 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 0).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 0).abs <= Smith::DELTA }

    # Test widened case
    result = @widened.inverse( 1 )
    assert_equal 1, result.size
    assert_not_nil result.index {|v| (v - 0).abs <= Smith::DELTA }
    result = @widened.inverse( 0.9862071167439163 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 1).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 1).abs <= Smith::DELTA }
    result = @widened.inverse( 0.9459594689067655 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 2).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 2).abs <= Smith::DELTA }
    result = @widened.inverse( 0.8007374029168081 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 4).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 4).abs <= Smith::DELTA }
    result = @widened.inverse( 0.6065306597126334 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 6).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 6).abs <= Smith::DELTA }
    result = @widened.inverse( 0.1353352832366127 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 12).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 12).abs <= Smith::DELTA }
    result = @widened.inverse( 0.0 )
    assert_equal 2, result.size
    assert result.include? -Smith::INF
    assert result.include? Smith::INF

    # Test narrowed case
    result = @narrowed.inverse( 1.0 )
    assert_equal 1, result.size
    assert_not_nil result.index {|v| (v - 0.0).abs <= Smith::DELTA }
    result = @narrowed.inverse( 0.9801986733067553 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 0.1).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 0.1).abs <= Smith::DELTA }
    result = @narrowed.inverse( 0.9231163463866358 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 0.2).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 0.2).abs <= Smith::DELTA }
    result = @narrowed.inverse( 0.6065306597126334 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 0.5).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 0.5).abs <= Smith::DELTA }
    result = @narrowed.inverse( 0.1353352832366127 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 1.0).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 1.0).abs <= Smith::DELTA }
    result = @narrowed.inverse( 0.0003354626279025 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 2.0).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 2.0).abs <= Smith::DELTA }
    result = @widened.inverse( 0.0 )
    assert_equal 2, result.size
    assert result.include? -Smith::INF
    assert result.include? Smith::INF
  end
end
