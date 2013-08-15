require File.expand_path( File.join( File.dirname(__FILE__), '../constants' ) )
require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class SigmoidalDifferenceMembershipFunction < Smith::Fuzzy::MembershipFunction
      #
      # alpha1, alpha2: Curvature of left and right side of peak. Make same for
      #                 a symmetrical curve. Recommend -> [12..20]
      # zeta1, zeta2: Their difference is the width of the curve. Their midpoint
      #               is x-coordinate of peak's center. Recommend -> [-8..8]
      def initialize( name, alpha1, alpha2, zeta1, zeta2 )
        super( name )
        @alpha1 = alpha1.to_f
        @alpha2 = alpha2.to_f
        @zeta1 = zeta1.to_f
        @zeta2 = zeta2.to_f
        
        sigmoidal_difference = lambda do |x| 
          sigmoidal1 = (1.0/(1.0 + Smith::EULER**(-@alpha1*(x-zeta1))))
          sigmoidal2 = (1.0/(1.0 + Smith::EULER**(-@alpha2*(x-zeta2))))
          sigmoidal1 - sigmoidal2
        end
        
        add( Range.new(-Smith::INFINITY, Smith::INFINITY), sigmoidal_difference )
      end
    end
  end
end