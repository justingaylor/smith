require File.expand_path( File.join( File.dirname(__FILE__), '../../constants' ) )
require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class GaussianFunction < Smith::Fuzzy::MembershipFunction
      def initialize( x_center, width )
        super()
        @x_center = x_center.to_f
        @width = width.to_f
        
        # The Gaussian function
        gaussian = lambda do |x| 
          Math::E**(-((x-@x_center)**2)/(2*(@width**2)))
        end
        
        # The inverse function of the Gaussian
        gaussian_inverse = lambda do |y|
          t = Math.sqrt( -2*(@width**2)*Math.log(y) )
          return (@x_center - t), (@x_center + t)
        end
        
        # The domain and range of the function
        domain = (-Smith::INF..Smith::INF)
        range  = (0.0..1.0)
        
        add( gaussian, gaussian_inverse, domain, range )
      end
      
    end
  end
end