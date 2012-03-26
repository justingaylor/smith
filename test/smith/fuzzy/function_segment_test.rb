require File.expand_path( File.join( File.dirname(__FILE__), "../../helper" ) )

require 'test/unit'
require 'smith/fuzzy/function_segment'

class FunctionSegmentTest < Test::Unit::TestCase
  def test_creation
    pf = Smith::Fuzzy::FunctionSegment.new
    assert_not_nil pf
    assert_nil pf.range
    assert_nil pf.proc
  end
  
  def test_creation_with_params
    pf = Smith::Fuzzy::FunctionSegment.new( (0.0..10.0), lambda {|x| x } )
    assert_not_nil pf
    assert_not_nil pf.range
    assert_not_nil pf.proc
  end
  
  def test_set_range
    pf = Smith::Fuzzy::FunctionSegment.new
    pf.range = Range.new(0.0,10.0)
    assert_equal pf.range.first, 0.0
    assert_equal pf.range.last, 10.0
  end
  
  def test_set_proc
    pf = Smith::Fuzzy::FunctionSegment.new
    pf.proc = lambda {|x| x }
    assert_not_nil pf.proc
  end
  
  def test_invocation_correct_range
    func = Smith::Fuzzy::FunctionSegment.new( (0.0..10.0), lambda {|x| x } )
    assert_equal func.call( 0.0 ), 0.0
    assert_equal func.call( 0.5 ), 0.5
    assert_equal func.call( 2.5 ), 2.5
    assert_equal func.call( 3.0 ), 3.0
  end
  
  def test_invocation_invalid_range_raises_exception
    func = Smith::Fuzzy::FunctionSegment.new( (0.0..10.0), lambda {|x| x } )
    assert_raise ( Smith::Fuzzy::ValueOutsideDomainError ) do
      func.call( 11.0 )
    end
    assert_raise ( Smith::Fuzzy::ValueOutsideDomainError ) do
      func.call( -1.0 )
    end
  end
end