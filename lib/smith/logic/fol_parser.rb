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

      rule(:lparen)      { match('(') >> space? }
      rule(:rparen)      { match(')') >> space? }
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
      rule(:variable)    { loweralphanum.as(:var) }

      # A constant is an upper-case letter followed by 0 or more upper-case letters or digits
      rule(:constant)    { upperalphanum.as(:const) }

      # A predicate is an upper-case letter followed by 1 or more lower-case letters or digits
      rule(:predicate)   { (camelalphanum >> camelalphanum.maybe).as(:pred) }

      # A function name is the same as a constant
      rule(:function)    { constant }

      #############################################
      # GRAMMAR PARTS
      #############################################

      # A function call is function name followed by some spaces, a left parenthesis,
      # any number of comma-separated terms and a right parenthesis.
      rule(:funccall) { (function >> lparen >> term >> (comma >> term).repeat >> space? >> rparen).as(:funccall) }

      # A function is 0 or more spaces, followed by a variable, constant or function
      # call, followed by 0 or more spaces
      rule(:term)     { space? >> (variable | constant | funccall) >> space? }

      #rule(:expression) { variable | constant | predicate | connective }

      #############################################
      # ROOT (where parser begins solving)
      #############################################
      root(:term)
    end
  end
end

run_this = false
if run_this
  def parse(str)
    fol = Smith::Logic::FolParser.new

    fol.parse(str)
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
  end

puts parse "AGE(x)"
end

