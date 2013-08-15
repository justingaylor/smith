

module Smith
  module Fuzzy
    class Set
      attr_accessor :name
      
      def initialize( name = nil, function = nil )
        @name = name
        @f = function
      end
      
    end
  end
end