require File.expand_path( File.join( File.dirname(__FILE__), '../../core/function' ) )

module Smith
  module Fuzzy
    class MembershipFunction < Smith::Core::Function
      
      def initialize
        super()
      end
      
      def call( x )
        # Check that the membership function (lambda) has been set
        unless self.segments > 0
          raise MembershipFunctionNotSetError, 
            "Membership function is nil. Set with add method."
        end
        
        result = super( x )

        # Check that result was a proper Degree of Membership (0.0 to 1.0)
        if not (0.0..1.0).member?( result )
          raise InvalidMembershipValueError, 
            "Membership value must be between 0.0 and 1.0. Was #{result}."
        end
        result
      end

      def inverse( y )
        # Check that input was a proper Degree of Membership (0.0 to 1.0)
        if not (0.0..1.0).member?( y )
          raise InvalidMembershipValueError, 
            "Membership value must be between 0.0 and 1.0. Was #{y}."
        end
        
        super( y )
      end

    end
    
    #
    # Exceptions
    #
    class MembershipFunctionNotSetError < Exception
    end
    class InvalidMembershipValueError < Exception
    end
  end
end