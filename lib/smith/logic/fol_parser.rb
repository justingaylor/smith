require 'parslet'

module Smith
  module Logic
    class FolParser < Parslet::Parser
      #############################################
      # SINGLE CHARACTER RULES
      #############################################
      rule(:lowerletter) { match('[a-z]').repeat(1) }
      rule(:upperletter) { match('[A-Z]').repeat(1) }
      rule(:digit)       { match('[0-9]').repeat(1) }

      rule(:lparen)      { match('(') >> space? }
      rule(:rparen)      { match(')') >> space? }
      rule(:comma)       { match(',') >> space? }

      rule(:space)       { match('\s').repeat(1) }
      rule(:space?)      { space.maybe }

      #############################################
      # MULTIPLE CHARACTER RULES
      #############################################

      # A lower-case alphanum is a lower-case letter followed by zero or more lower-case letters or digits
      rule(:loweralphanum) { (lowerletter.repeat(1) >> (lowerletter | digit).repeat) }

      # A upper-case alphanum is an upper-case letter followed by zero or more upper-case letters or digits
      rule(:upperalphanum) { (upperletter.repeat(1) >> (upperletter | digit).repeat) }

      # A camel-case alphanum is an upper-case letter followed by one or more lower-case letters or digits
      rule(:camelalphanum) { (upperletter.repeat(1) >> (lowerletter | digit).repeat(1,nil)) }

      #############################################
      # LOGICAL OPERATORS
      #############################################

      rule(:and_op)     { match('&').as(:and) >> space? }
      rule(:or_op)      { match('\|').as(:or) >> space? }
      rule(:implies_op) { (match('=') >> match('>')).as(:implies) >> space? }
      rule(:iff_op)     { (match('<') >> match('=') >> match('>')).as(:iff) >> space? }
      rule(:not_op)     { match('~').as(:not) >> space? }

      # A unary connective is NOT
      rule(:unary_connective)   { not_op }

      # A binary connective is AND, OR, IMPLIES or IFF
      rule(:binary_connective)  { and_op | or_op | implies_op | iff_op }

      # A binary connective is AND, OR, IMPLIES or IFF
      rule(:connective)         { binary_connective | unary_connective }

      #############################################
      # SYMBOLS
      #############################################

      # A variable is a lower-case letter followed by 0 or more letters or digits
      rule(:variable)    { loweralphanum.as(:var) >> space? }

      # A constant is an upper-case letter followed by 0 or more upper-case letters or digits
      rule(:constant)    { upperalphanum.as(:const) >> space? }

      # A predicate is an upper-case letter followed by 1 or more lower-case letters or digits
      rule(:predicate)   { (camelalphanum >> camelalphanum.maybe).as(:pred) >> space? }

      #############################################
      # GRAMMAR PARTS
      #############################################
      rule(:expression) { variable | constant | predicate | connective }

      #############################################
      # ROOT (where parser begins solving)
      #############################################
      root(:expression)
    end
  end
end
