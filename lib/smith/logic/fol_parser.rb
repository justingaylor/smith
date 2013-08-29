#--
# Copyright (c) 2013, Justin Gaylor, justin.gaylor@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in the USA.
#++

require 'parslet'

module Smith
  module Logic
    class FolParser < Parslet::Parser
      #############################################
      # SINGLE CHARACTER RULES
      #############################################

      rule(:lparen)      { match('\(') >> space? }
      rule(:rparen)      { match('\)') >> space? }
      rule(:comma)       { match(',') >> space? }

      rule(:space)       { match('\s').repeat(1) }
      rule(:space?)      { space.maybe }

      #############################################
      # MULTIPLE CHARACTER RULES
      #############################################

      # A lower-case alphanum is a lower-case letter followed by zero or more lower-case letters or digits
      rule(:loweralphanum) { match('[a-z]') >> match('[a-z0-9]').repeat }

      # A upper-case alphanum is an upper-case letter followed by zero or more upper-case letters or digits
      rule(:upperalphanum) { match('[A-Z]') >> match('[A-Z0-9]').repeat }

      # A camel-case alphanum is an upper-case letter followed by one or more lower-case letters or digits
      rule(:camelalphanum) { (match('[A-Z]') >> match('[a-z0-9]').repeat).repeat(1) }

      #############################################
      # LOGICAL OPERATORS
      #############################################

      rule(:and_op)     { match('&').as(:and) }
      rule(:or_op)      { match('\|').as(:or) }
      rule(:implies_op) { (match('=') >> match('>')).as(:implies) }
      rule(:iff_op)     { (match('<') >> match('=') >> match('>')).as(:iff) }
      rule(:not_op)     { match('~').as(:not) }

      # A unary operator is NOT (possibly preceded or followed by spaces)
      rule(:unary_op)   { space? >> not_op >> space? }

      # A binary operator is AND, OR, IMPLIES or IFF (possibly preceded or followed by spaces)
      rule(:binary_op)  { space? >> (and_op | or_op | implies_op | iff_op) >> space? }

      #############################################
      # SYMBOLS
      #############################################

      # A variable is a lower-case letter followed by 0 or more letters or digits
      rule(:variable)    { loweralphanum.as(:var) }

      # A constant is an upper-case letter followed by 0 or more upper-case letters or digits
      rule(:constant)    { upperalphanum.as(:const) }

      # A predicate is an upper-case letter followed by 1 or more lower-case letters or digits
      rule(:predicate)   { (camelalphanum >> camelalphanum.maybe).as(:pred) }

      #############################################
      # GRAMMAR PARTS
      #############################################

      # An argument list is a list of comma-separated terms.
      rule(:arglist) { (term >> (comma >> term).repeat).as(:args) }

      # A function call is a constant followed by some spaces, a left parenthesis,
      # any number of comma-separated terms and a right parenthesis.
      rule(:funcall) { (constant >> lparen >> arglist.maybe >> rparen).as(:funcall) }

      # A function call is a constant followed by some spaces, a left parenthesis,
      # any number of comma-separated terms and a right parenthesis.
      rule(:predcall) { (predicate >> lparen >> arglist.maybe >> rparen).as(:predcall) }

      # A connective clause is a predicate call followed by a binary operator followed
      # by a predicate call.
      rule(:connective_clause)  { (predcall.as(:left) >> binary_op >> predcall.as(:right)).as(:clause) }

      # A function is 0 or more spaces, followed by a variable, constant or function
      # call, followed by 0 or more spaces.
      rule(:term)     { space? >> (funcall | variable | constant) >> space? }

      # A first-order logic formula is a predicate call
      rule(:formula)  { (connective_clause | predcall).as(:formula) }

      #############################################
      # ROOT (where parser begins solving)
      #############################################
      root(:formula)
    end
  end
end

run_this = false
if run_this
  def parse(str)
    fol = Smith::Logic::FolParser.new

    fol.formula.parse(str)
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
  end

puts parse "Person(JOE) & Person(ANN)"
end

