require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class TriangularMembershipFunction < Smith::Fuzzy::MembershipFunction
      def initialize( name, slope, x_peak )
        super( name )
        @slope = slope.to_f
        @x_peak = x_peak.to_f
        
        # Calculate ranges for both sides (segments) of triangle function
        range_left  = @x_peak - (1.0/@slope)
        range_right = @x_peak + (@x_peak - range_left)
        
        # Calculate line functions for each side (segment) of triangle
        left  = lambda {|x| (@slope * (x - @x_peak)) + 1.0 }
        right = lambda {|x| (-@slope * (x - @x_peak)) + 1.0 }
        
        # Add segments for piecemeal function (two lines and two zero functions
        # for areas outside of the triangle function)
        add( Range.new(-Smith::INFINITY, range_left), lambda {|x| 0.0 } )
        add( Range.new(range_left, @x_peak), left )
        add( Range.new(@x_peak, range_right), right )
        add( Range.new(range_right, Smith::INFINITY, true), lambda {|x| 0.0 } )
      end
    end
  end
end