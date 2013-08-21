require 'parslet'

module Smith
  module Logic
    class FirstOrderLogic < Parslet::Parser
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
      # LOGICAL OPERATORS
      #############################################

      rule(:and_op)     { match('&').as(:and) >> space? }
      rule(:or_op)      { match('\|').as(:or) >> space? }
      rule(:implies_op) { (match('=') >> match('>')).as(:implies) >> space? }
      rule(:iff_op)     { (match('<') >> match('=') >> match('>')).as(:iff) >> space? }
      rule(:not_op)     { match('~').as(:not) >> space? }

      # A connective is AND, OR, IMPLIES or IFF
      rule(:connective)  { and_op | or_op | implies_op | iff_op }

      #############################################
      # SYMBOLS
      #############################################

      # A variable is a lower-case letter followed by 0 or more letters or digits
      rule(:variable)    { (lowerletter.repeat(1) >> (lowerletter | digit).repeat).as(:var) >> space? }

      # A constant is an upper-case letter followed by 0 or more upper-case letters or digits
      rule(:constant)    { (upperletter.repeat(1) >> (upperletter | digit).repeat).as(:const) >> space? }

      # A predicate is an upper-case letter followed by 1 or more lower-case letters or digits
      rule(:predicate)   { (upperletter.repeat(1) >> (lowerletter | digit).repeat(1,nil)).as(:pred) >> space? }

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


# Tests
run_tests = true
if run_tests
  puts Smith::Logic::FirstOrderLogic.new.parse("x3")       == {:var => "x3"}
  puts Smith::Logic::FirstOrderLogic.new.parse("x")        == {:var => "x"}
  puts Smith::Logic::FirstOrderLogic.new.parse("var1")     == {:var => "var1"}

  puts Smith::Logic::FirstOrderLogic.new.parse("D")        == {:const => "D"}
  puts Smith::Logic::FirstOrderLogic.new.parse("JIM")      == {:const => "JIM"}
  puts Smith::Logic::FirstOrderLogic.new.parse("JOE ")     == {:const => "JOE"}

  puts Smith::Logic::FirstOrderLogic.new.parse("Friend")   == {:pred => "Friend"}
  puts Smith::Logic::FirstOrderLogic.new.parse("Brother ") == {:pred => "Brother"}

  puts Smith::Logic::FirstOrderLogic.new.parse("&")   == {:and => "&"}
  puts Smith::Logic::FirstOrderLogic.new.parse("|")   == {:or => "|"}
  puts Smith::Logic::FirstOrderLogic.new.parse("=>")  == {:implies => "=>"}
  puts Smith::Logic::FirstOrderLogic.new.parse("<=>") == {:iff => "<=>"}
end