require File.expand_path( File.join( File.dirname(__FILE__), '../constants' ) )
require File.expand_path( File.join( File.dirname(__FILE__), 'function_segment' ) )

module Smith
  module Fuzzy
    class PiecemealFunction
      def initialize
        @funcs = []
      end
      
      def add( range, f )
        # Check that range doesn't overlap any existing ranges
        @funcs.each do |f|
          if f.range.include? range.first or f.range.include? range.last
            unless f.range.first == range.last or f.range.last == range.first
              raise FunctionRangesOverlapError, 
                "Range given overlaps range of segement in piecemeal function"
            end
          end
        end
        @funcs << Smith::Fuzzy::FunctionSegment.new( range, f )
      end
      
      def segments
        @funcs.size
      end
      
      def call( x )
        @funcs.each do |f|
          if f.range.member? x
            return f.call( x )
          end
        end
        raise UndefinedRangeError, "Function is undefined for value #{x}."
      end
    end
    
    class FunctionRangesOverlapError < Exception
    end
    class UndefinedRangeError < Exception
    end
  end
end