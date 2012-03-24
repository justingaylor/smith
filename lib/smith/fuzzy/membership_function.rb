
module Smith
  module Fuzzy
    class MembershipFunction
      attr_writer :f
      
      def initialize( f = nil )
        @f = f
      end
      
      def call( n )
        result = @f.call( n )
        if 0.0 > result or 1.0 < result then
          puts "Result: #{result}"
          raise InvalidMembershipValueError, 
            "Membership value (#{result}) must be between 0.0 and 1.0"
        end
        result
      end
    end
    
    class InvalidMembershipValueError < Exception
    end
  end
end