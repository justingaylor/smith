#Smith::Fuzzy::LinguisticVariable := A quantity about which measurement is to be performed (e.g. "temperature", "age", "karma", etc)
#Smith::Fuzzy::DOM                := A degree of membership ranging from 0.0 to 1.0 of a variable in a fuzzy set
#Smith::Fuzzy::Set                := A representation of a potential value for a linguistic variable (e.g. "hot/warm/cold", "young/middle-aged/old", "good/neutral/evil")
#Smith::Fuzzy::MembershipFunction := A function use to determine the degree of membership of a linguistic variable in a fuzzy set
#Smith::Fuzzy::Modifier           := Adverbial modifiers to fuzzy sets which change their extent (e.g. "very", "somewhat", "more or less", "extremely")
#Smith::Fuzzy::Operator           := And, Or, Not, etc; operate on Smith::Fuzzy::Variable objects
#Smith::Fuzzy::RuleMatrix         := A collection of rules to control behavior

=begin



=end


module Smith
  module Fuzzy
    #
    # A measureable quantity which can be reasoned upon (e.g. "temperature", "age", 
    # "size", "color", "distance", etc).
    #
    class LinguisticVariable
      attr_reader :name
      attr_accessor :val
  
      def initialize( name )
        @name = name
        @membership_functions = {}
        @val = nil
      end
    end
  end
end
