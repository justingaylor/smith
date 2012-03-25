
module Smith
  module Fuzzy
    class MembershipFunction
      attr_writer :f
      attr_accessor :name
      
      def initialize( name, f = nil )
        @name = name
        @f = f
      end
      
      def call( n )
        # Check that the membership function (lambda) has been set
        unless @f
          raise MembershipFunctionNotSetError, 
            "Membership function is nil. Set using MembershipFunction#f attribute."
        end
        
        result = @f.call( n )
        
        # Check that result was a proper Degree of Membership (0.0 to 1.0)
        if result < 0.0 or 1.0 < result
          raise InvalidMembershipValueError, 
            "Membership value must be between 0.0 and 1.0. Was #{result}."
        end
        result
      end
    end
    
    #
    # Exceptions
    #
    class InvalidMembershipValueError < Exception
    end
    class MembershipFunctionNotSetError < Exception
    end
    
  end
end