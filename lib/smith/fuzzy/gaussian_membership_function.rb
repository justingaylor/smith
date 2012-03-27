require File.expand_path( File.join( File.dirname(__FILE__), '../constants' ) )
require File.expand_path( File.join( File.dirname(__FILE__), 'membership_function' ) )

module Smith
  module Fuzzy
    class GaussianMembershipFunction < Smith::Fuzzy::MembershipFunction
      def initialize( name, x_center, width )
        super( name )
        @x_center = x_center.to_f
        @width = width.to_f
        
        gaussian = lambda {|x| Smith::EULER**(-((@x_center-x)**2)/(2*(@width**2))) }
        
        add( Range.new(-Smith::INFINITY, Smith::INFINITY), gaussian )
      end
    end
  end
end