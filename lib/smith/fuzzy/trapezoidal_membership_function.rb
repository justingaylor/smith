require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class TrapezoidalMembershipFunction < Smith::Fuzzy::MembershipFunction
      def initialize( name, x_center, peak_width, total_width )
        super( name )
        @x_center = x_center.to_f
        @peak_width = peak_width.to_f
        @total_width = total_width.to_f
        
        # Calculate x-coordinates for each point of trapezoid
        x_top_left     = x_center - (@peak_width/2.0)
        x_top_right    = x_center + (@peak_width/2.0)
        x_bottom_left  = x_center - (@total_width/2.0)
        x_bottom_right = x_center + (@total_width/2.0)
        
        # Calculate ranges for each segment of trapezoid function
        range_outside_left = Range.new(-Smith::INFINITY, x_bottom_left)
        range_left   = Range.new( x_bottom_left, x_top_left )
        range_middle = Range.new( x_top_left, x_top_right )
        range_right  = Range.new( x_top_right, x_bottom_right )
        range_outside_right = Range.new(x_bottom_right, Smith::INFINITY)
        
        # Calculate slope of lines on both sides of trapezoid
        slope = 1.0/(x_top_left - x_bottom_left)
        
        # Calculate functions for each segment of trapezoid
        outside = lambda {|x| 0.0 }
        left   = lambda {|x| (slope * (x - x_top_left)) + 1.0 }
        middle = lambda {|x| 1.0 }
        right  = lambda {|x| (-slope * (x - x_top_right)) + 1.0 }
        
        # Add segments for piecemeal function (two lines and two zero functions
        # for areas outside of the triangle function)
        add( range_outside_left, outside )
        add( range_left, left )
        add( range_middle, middle )
        add( range_right, right )
        add( range_outside_right, outside )
      end
    end
  end
end