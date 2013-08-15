require File.expand_path( File.join( File.dirname(__FILE__), '../constants' ) )
require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class BellMembershipFunction < Smith::Fuzzy::MembershipFunction
      #
      # alpha: width of the top of the bell curve. Recommend -> x != 0
      # beta:  curviness of bell curve edges. Recommend -> [1.0..~30]
      #        NOTE: beta < ~1.0 results in a spike similar to the letter A
      #        with the sides pushed in (accelerating increase to the peak
      #        at x=zeta.)
      # zeta:  x-value of center point of bell curve. Recommend -> (-inf...inf)
      #
      def initialize( name, alpha, beta, zeta )
        super( name )
        @alpha = alpha.to_f
        @beta  = beta.to_f
        @zeta  = zeta.to_f
        
        bell = lambda do |x|
          (1.0/(1.0+((x-zeta)/alpha).abs**(2*beta)))
        end
        
        add( Range.new(-Smith::INFINITY, Smith::INFINITY), bell )
      end
    end
  end
end