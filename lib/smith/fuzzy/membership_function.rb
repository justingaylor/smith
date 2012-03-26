require 'smith/fuzzy/piecemeal_function'

module Smith
  module Fuzzy
    class MembershipFunction < Smith::Fuzzy::PiecemealFunction
      attr_accessor :name
      
      def initialize( name )
        super()
        @name = name
      end
      
      def call( n )
        # Check that the membership function (lambda) has been set
        unless self.segments > 0
          raise MembershipFunctionNotSetError, 
            "Membership function is nil. Set with f attribute."
        end
        
        #result = call( n )
        result = super( n )

        # Check that result was a proper Degree of Membership (0.0 to 1.0)
        if not (0.0..1.0).member?( result )
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