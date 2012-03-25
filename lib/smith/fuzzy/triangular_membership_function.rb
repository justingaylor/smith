require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class TriangularMembershipFunction < Smith::Fuzzy::MembershipFunction
      def initialize( name, slope, peak_x )
        @slope = slope.to_f
        @peak_x = peak_x.to_f
        f = lambda do |x|
          # If we are on the left side of the peak, flip x to corresponding 
          # value on right-side of the peak
          x = @peak_x + (x - @peak_x).abs if x < @peak_x
          
          # Calculate the membership value if inside the triangle, otherwise 
          # return 0.0 if we are outside of the triangular function's range
          res = (x < ((1.0/@slope)+@peak_x)) ? (-@slope*x + 1.0) + @peak_x : 0.0
        end
        super( name, f )
      end
    end
  end
end