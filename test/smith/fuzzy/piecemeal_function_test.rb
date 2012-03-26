require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/piecemeal_function'

class PiecemealFunctionTest < Test::Unit::TestCase
  def test_creation
    pf = Smith::Fuzzy::PiecemealFunction.new
    assert_not_nil pf
  end
  
  def test_adding_functions
    pf = Smith::Fuzzy::PiecemealFunction.new
    pf.add( Range.new(0,3), lambda {|x| x } )
    pf.add( Range.new(3,10), lambda {|x| x*x*x } )
    pf.add( Range.new(-10,0), lambda {|x| x*x } )
    assert_equal 3, pf.segments
  end
  
  def test_adding_functions_with_overlapping_ranges_raises_exception
    pf = Smith::Fuzzy::PiecemealFunction.new
    pf.add( Range.new(0,3), lambda {|x| x } )
    assert_raise( Smith::Fuzzy::FunctionRangesOverlapError ) do
      pf.add( Range.new(-1,1), lambda {|x| x*x } )
    end
    assert_raise( Smith::Fuzzy::FunctionRangesOverlapError ) do
      pf.add( Range.new(1,4), lambda {|x| x*x } )
    end
    assert_raise( Smith::Fuzzy::FunctionRangesOverlapError ) do
      pf.add( Range.new(1,2), lambda {|x| x*x } )
    end
  end
  
  def test_invocation_defined_range
    pf = Smith::Fuzzy::PiecemealFunction.new
    pf.add( Range.new(-10,2), lambda {|x| x*x } )
    pf.add( Range.new(2,3),   lambda {|x| x } )
    pf.add( Range.new(3,10),  lambda {|x| x*x*x } )
    assert_equal 100,  pf.call( -10 ) # square
    assert_equal 1,    pf.call( -1 )  # square
    assert_equal 2,    pf.call( 2 )   # identity
    assert_equal 0,    pf.call( 0 )   # square
    assert_equal 2.25, pf.call( 1.5 ) # square
    assert_equal 27,   pf.call( 3 )   # cube
    assert_equal 64,   pf.call( 4 )   # cube
  end
  
  def test_invocation_undefined_range_raises_exception
    pf = Smith::Fuzzy::PiecemealFunction.new
    pf.add( Range.new(-10,2), lambda {|x| x*x } )
    pf.add( Range.new(3,10),  lambda {|x| x*x*x } )
    assert_raise( Smith::Fuzzy::UndefinedRangeError ) do
      pf.call(2.5)
    end
  end
end