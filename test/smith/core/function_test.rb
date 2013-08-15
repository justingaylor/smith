require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/core/function'

class FunctionTest < Test::Unit::TestCase
  
  def setup
    @empty = Smith::Core::Function.new
    
    @f = Smith::Core::Function.new
    @f.add( lambda {|x| x*x }, lambda {|y| [-Math.sqrt(y),Math.sqrt(y)] }, 
            (-10..0), (0..100) )
    @f.add( lambda {|x| x }, lambda {|y| y }, (0..3), (0..3) )
    @f.add( lambda {|x| x*x*x }, lambda {|y| y**(1/3.0) }, (3..10), (27..1000) )
    
    @no_inv = Smith::Core::Function.new
    @no_inv.add( lambda {|x| x*x }, nil, (-10..0), nil )
  end
  
  def test_creation
    assert_not_nil @empty
  end
  
  def test_adding_functions
    assert_equal 3, @f.segments
    @f.add( lambda {|x| x**4 }, lambda {|y| y**(1.0/4) }, (10..20), (0..160000) )
    assert_equal 4, @f.segments
  end
  
  def test_adding_functions_with_overlapping_domains_raises_exception
    assert_raise( Smith::Core::FunctionSegmentDomainOverlapError ) do
      @f.add( lambda {|x| x*x }, nil, (-1..1), nil )
    end
    assert_raise( Smith::Core::FunctionSegmentDomainOverlapError ) do
      @f.add( lambda {|x| x*x }, nil, (1..4), nil )
    end
    assert_raise( Smith::Core::FunctionSegmentDomainOverlapError ) do
      @f.add( lambda {|x| x*x }, nil, (1..2), nil )
    end
  end
  
  def test_call_valid_domain
    assert_in_delta 100,  @f.call( -10 ), Smith::DELTA  # square
    assert_in_delta 1,    @f.call( -1 ), Smith::DELTA   # square
    assert_in_delta 2,    @f.call( 2 ), Smith::DELTA    # identity
    assert_in_delta 0,    @f.call( 0 ), Smith::DELTA    # square
    assert_in_delta 2.25, @f.call( -1.5 ), Smith::DELTA # square
    assert_in_delta 27,   @f.call( 3 ), Smith::DELTA    # cube
    assert_in_delta 64,   @f.call( 4 ), Smith::DELTA    # cube
  end
  
  def test_call_invalid_domain_raises_exception
    assert_raise( Smith::Core::UndefinedDomainError ) do
      @f.call(-10.5)
    end
    assert_raise( Smith::Core::UndefinedDomainError ) do
      @f.call(10.5)
    end
  end
  
  def test_inverse
    result = @f.inverse( 0 )
    assert_equal 1, result.size
    assert_not_nil result.index {|v| (v - 0).abs <= Smith::DELTA }
    result = @f.inverse( 100 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 10).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 4.641588833612778).abs <= Smith::DELTA }
    result = @f.inverse( 1 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v - 1).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v + 1).abs <= Smith::DELTA }
    result = @f.inverse( 2 )
    assert_equal 2, result.size
    assert result.include? -1.4142135623730951
    assert result.include? 2
    result = @f.inverse( 2.25 )
    assert_equal 2, result.size
    assert result.include? -1.5
    assert_not_nil result.index {|v| (v - 2.25).abs <= Smith::DELTA }
    result = @f.inverse( 27 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 5.196152422706632).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 3).abs <= Smith::DELTA }
    result = @f.inverse( 64 )
    assert_equal 2, result.size
    assert_not_nil result.index {|v| (v + 8).abs <= Smith::DELTA }
    assert_not_nil result.index {|v| (v - 4).abs <= Smith::DELTA }
  end
end