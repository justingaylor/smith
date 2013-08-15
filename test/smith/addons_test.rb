require File.expand_path( File.join( File.dirname(__FILE__), "../helper" ) )

require 'test/unit'
require 'smith/constants'
require 'smith/addons'

class AddonsTest < Test::Unit::TestCase
  
  def test_range_neighbors
    assert !(Range.new(0, 5).neighbors? Range.new(-Smith::INF, Smith::INF))
    assert !(Range.new(-Smith::INF, Smith::INF).neighbors? Range.new(0, 5))
    assert !(Range.new(0, 5).neighbors? Range.new(-10, 10))
    assert !(Range.new(-10, 10).neighbors? Range.new(0, 5))
    assert !(Range.new(0, 5).neighbors? Range.new(-5, 5))
    assert !(Range.new(0, 5).neighbors? Range.new(0, 10))
    assert !(Range.new(0, 5).neighbors? Range.new(-2, 3))
    assert !(Range.new(0, 5).neighbors? Range.new(2, 8))
    assert !(Range.new(0, 5).neighbors? Range.new(0, 5))
    assert Range.new(0, 5).neighbors? Range.new(5, 10)
    assert Range.new(0, 5).neighbors? Range.new(-5, 0)
    assert !(Range.new(0, 5).neighbors? Range.new(7, 10))
    assert !(Range.new(0, 5).neighbors? Range.new(10, -2))
  end
  
  def test_range_overlaps
    assert Range.new(0, 5).overlaps? Range.new(-Smith::INF, Smith::INF)
    assert Range.new(-Smith::INF, Smith::INF).overlaps? Range.new(0, 5)
    assert Range.new(0, 5).overlaps? Range.new(-10, 10)
    assert Range.new(-10, 10).overlaps? Range.new(0, 5)
    assert Range.new(0, 5).overlaps? Range.new(-5, 5)
    assert Range.new(0, 5).overlaps? Range.new(0, 10)
    assert Range.new(0, 5).overlaps? Range.new(-2, 3)
    assert Range.new(0, 5).overlaps? Range.new(2, 8)
    assert Range.new(0, 5).overlaps? Range.new(0, 5)
    assert !(Range.new(0, 5).overlaps? Range.new(5, 10))
    assert !(Range.new(0, 5).overlaps? Range.new(-5, 0))
    assert !(Range.new(0, 5, true).overlaps? Range.new(5, 10, true))
    assert !(Range.new(0, 5, true).overlaps? Range.new(-5, 0, true))
    assert !(Range.new(0, 5).overlaps? Range.new(7, 10))
    assert !(Range.new(0, 5).overlaps? Range.new(10, -2))
  end
end