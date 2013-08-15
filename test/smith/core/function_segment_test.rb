require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/constants'
require 'smith/core/function_segment'

class FunctionSegmentTest < Test::Unit::TestCase
  def setup
    @f = Smith::Core::FunctionSegment.new( lambda {|x| x },
                                           lambda {|y| y },
                                           (0.0..10.0), 
                                           (0.0..10.0) )
    @cube = Smith::Core::FunctionSegment.new( lambda {|x| x**3 },
                                              lambda {|y| y**(1.0/3) },
                                              (0.0..10.0), 
                                              (0.0..1000.0) )    
    @square = Smith::Core::FunctionSegment.new( lambda {|x| x*x },
                                                lambda {|y| [-Math.sqrt(y),Math.sqrt(y)] },
                                                (0.0..10.0), 
                                                (0.0..100.0) )
  end  
  
  def test_creation
    f = Smith::Core::FunctionSegment.new
    assert_not_nil f
    assert_nil f.domain
    assert_nil f.range
    assert_nil f.proc
    assert_nil f.inv
  end
  
  def test_creation_with_params
    assert_not_nil @f
    assert_not_nil @f.range
    assert_not_nil @f.domain
    assert_not_nil @f.proc
    assert_not_nil @f.inv
  end
  
  def test_set_range
    f = Smith::Core::FunctionSegment.new
    f.range = Range.new(0.0,10.0)
    assert_equal 0.0, f.range.first
    assert_equal 10.0, f.range.last
  end
  
  def test_set_proc
    f = Smith::Core::FunctionSegment.new
    f.proc = lambda {|x| x }
    assert_not_nil f.proc
  end
  
  def test_set_inv
    f = Smith::Core::FunctionSegment.new
    f.inv = lambda {|y| y }
    assert_not_nil f.inv
  end
  
  def test_call_correct_domain
    assert_in_delta 0.0, @f.call( 0.0 ), Smith::DELTA
    assert_in_delta 0.5, @f.call( 0.5 ), Smith::DELTA
    assert_in_delta 2.5, @f.call( 2.5 ), Smith::DELTA
    assert_in_delta 3.0, @f.call( 3.0 ), Smith::DELTA
    
    assert_in_delta 0.0, @cube.call( 0.0 ), Smith::DELTA
    assert_in_delta 0.125, @cube.call( 0.5 ), Smith::DELTA
    assert_in_delta 15.625, @cube.call( 2.5 ), Smith::DELTA
    assert_in_delta 27.0, @cube.call( 3.0 ), Smith::DELTA
    
  end
  
  def test_call_invalid_domain_raises_exception
    assert_raise ( Smith::Core::ValueOutsideDomainError ) do
      @f.call( 11.0 )
    end
    assert_raise ( Smith::Core::ValueOutsideDomainError ) do
      @f.call( -1.0 )
    end
  end
  
  def test_inverse_correct_range
    assert_in_delta 0.0, @f.inverse( 0.0 ).first, Smith::DELTA
    assert_in_delta 0.5, @f.inverse( 0.5 ).first, Smith::DELTA
    assert_in_delta 0.8, @f.inverse( 0.8 ).first, Smith::DELTA
    assert_in_delta 0.99999, @f.inverse( 0.99999 ).first, Smith::DELTA
    
    assert_in_delta 0.0, @cube.inverse( 0.0 ).first, Smith::DELTA
    assert_in_delta 0.5, @cube.inverse( 0.125 ).first, Smith::DELTA
    assert_in_delta 3, @cube.inverse( 27 ).first, Smith::DELTA
    assert_in_delta 4, @cube.inverse( 64 ).first, Smith::DELTA
    assert_in_delta 2.5, @cube.inverse( 15.625 ).first, Smith::DELTA
  end
  
  def test_inverse_invalid_range_raises_exception
    assert_raise ( Smith::Core::ValueOutsideRangeError ) do
      @f.inverse( 100 )
    end
    assert_raise ( Smith::Core::ValueOutsideRangeError ) do
      @f.inverse( -1.0 )
    end
  end
  
  def test_inverse_rejects_results_not_in_domain
    result = @square.inverse( 9 )
    assert !(result.include? -3.0)
    result = @square.inverse( 4 )
    assert !(result.include? -2.0)
  end
  
  def test_inverse_returns_array_of_floats
    @f.inverse( 0 ).each do |v|
      assert v.is_a? Float
    end
    @f.inverse( 10 ).each do |v|
      assert v.is_a? Float
    end
    @cube.inverse( 1000 ).each do |v|
      assert v.is_a? Float
    end
    @cube.inverse( 27 ).each do |v|
      assert v.is_a? Float
    end
  end
  
end