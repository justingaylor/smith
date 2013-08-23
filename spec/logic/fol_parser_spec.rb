require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require File.join(File.dirname(__FILE__), 'fol_parser_spec_helper')

describe Smith::Logic::FolParser do

  before(:each) do
    @parser = Smith::Logic::FolParser.new
  end

  describe "#parse" do

    context ":loweralphanum" do
      it "parses lower-case alphanumerics" do
        @parser.loweralphanum.parse('a').should == 'a'
        @parser.loweralphanum.parse('foo').should == 'foo'
        @parser.loweralphanum.parse('foo2').should == 'foo2'
        @parser.loweralphanum.parse('foo2bar').should == 'foo2bar'
        @parser.loweralphanum.parse('v3c70r').should == 'v3c70r'
      end
    end

    context ":upperalphanum" do
      it "parses upper-case alphanumerics" do
        @parser.upperalphanum.parse('G').should == 'G'
        @parser.upperalphanum.parse('G2').should == 'G2'
        @parser.upperalphanum.parse('JOHN').should == 'JOHN'
        @parser.upperalphanum.parse('LUV2LIVE').should == 'LUV2LIVE'
        @parser.upperalphanum.parse('V3C70R').should == 'V3C70R'
      end
    end

    context ":camelalphanum" do
      it "parses camel-case alphanumerics" do
        @parser.camelalphanum.parse('Go').should == 'Go'
        @parser.camelalphanum.parse('Good').should == 'Good'
        @parser.camelalphanum.parse('Go0d').should == 'Go0d'
        @parser.camelalphanum.parse('Go0d2Go').should == 'Go0d2Go'
      end
    end

    context ":variable" do
      VARIABLE_VALID_EXAMPLES.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.variable.parse(hash[:value]).should == hash[:expected]
        end
      end
    end

    context ":constant" do
      CONSTANT_VALID_EXAMPLES.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.constant.parse(hash[:value]).should == hash[:expected]
        end
      end
    end

    context ":predicate" do
      PREDICATE_VALID_EXAMPLES.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.predicate.parse(hash[:value]).should == hash[:expected]
        end
      end
    end

    context ":connective" do
      CONNECTIVE_VALID_EXAMPLES.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.connective.parse(hash[:value]).should == hash[:expected]
        end
      end
    end

    context ":term" do
      TERM_VALID_EXAMPLES.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.term.parse(hash[:value]).should == hash[:expected]
        end
      end
    end

    context "fail cases" do
      INVALID_EXAMPLES.each do |value|
        it "raises exception when parsing '#{value}'" do
          expect { @parser.parse(value) }.to raise_exception
        end
      end
    end

  end

end