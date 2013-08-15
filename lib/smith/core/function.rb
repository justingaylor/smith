require File.expand_path( File.join( File.dirname(__FILE__), '../constants' ) )
require File.expand_path( File.join( File.dirname(__FILE__), '../addons' ) )
require File.expand_path( File.join( File.dirname(__FILE__), 'function_segment' ) )

module Smith
  module Core
    class Function
      def initialize
        @funcs = []
      end
      
      def add( func, inv, domain, range )
        # Check that range doesn't overlap any existing ranges
        @funcs.each do |f|
          if f.domain.overlaps? domain
            raise FunctionSegmentDomainOverlapError, 
              "Domain given #{domain} overlaps existing segment's " +
              "domain: #{f.domain}"
          end
        end
        @funcs << Smith::Core::FunctionSegment.new( func, inv, domain, range )
      end
      
      def segments
        @funcs.size
      end
      
      def call( x )
        @funcs.each do |f|
          if f.domain.member? x
            return f.call( x )
          end
        end
        raise UndefinedDomainError, "Function is undefined for value #{x}."
      end
      
      def inverse( y )
        values = []
        # TODO: Sort the functions by domain?
        @funcs.each do |f|
          if f.range.member? y
            values += [f.inverse( y )]
          end
        end
        # Convert -0.0 to 0.0 and remove duplicates
        values = values.flatten.map {|v| (v == 0) ? v*v : v}
        values & values
      end
    end
    
    class FunctionSegmentDomainOverlapError < Exception
    end
    class UndefinedDomainError < Exception
    end
  end
end