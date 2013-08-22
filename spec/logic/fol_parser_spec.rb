require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Variable Test Data
VARIABLE_POSITIVE_TESTS = [
  {:value => "x",          :expected => {:var => "x"}},
  {:value => "x3",         :expected => {:var => "x3"}},
  {:value => "foobar45",   :expected => {:var => "foobar45"}},
  {:value => "foobar45zw", :expected => {:var => "foobar45zw"}}
]
VARIABLE_NEGATIVE_TESTS = ["x_", "fo_obar45", "foo bar"]

# Constant Test Data
CONSTANT_POSITIVE_TESTS = [
  {:value => "G",      :expected => {:const => "G"}},
  {:value => "EVE",    :expected => {:const => "EVE"}},
  {:value => "JUSTIN", :expected => {:const => "JUSTIN"}}
]
CONSTANT_NEGATIVE_TESTS = ["G_", "DAV__ID", "JUS~TIN"]

# Predicate Test Data
PREDICATE_POSITIVE_TESTS = [
  {:value => "Person",     :expected => {:pred => "Person"}},
  {:value => "Brother",    :expected => {:pred => "Brother"}},
  {:value => "NicePerson", :expected => {:pred => "NicePerson"}}
]
PREDICATE_NEGATIVE_TESTS = ["Nice_", "Nice_Person", "Nice Person"]

# Connective Test Data
CONNECTIVE_POSITIVE_TESTS = [
  {:value => "&",   :expected => {:and => "&"}},
  {:value => "|",   :expected => {:or => "|"}},
  {:value => "=>",  :expected => {:implies => "=>"}},
  {:value => "<=>", :expected => {:iff => "<=>"}},
  {:value => "~",   :expected => {:not => "~"}}
]

describe Smith::Logic::FolParser do

  before(:each) do
    @parser = Smith::Logic::FolParser.new
  end

  describe "#parse" do

    context "VARIABLES" do
      VARIABLE_POSITIVE_TESTS.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.parse(hash[:value]).should == hash[:expected]
        end
      end

      VARIABLE_NEGATIVE_TESTS.each do |value|
        it "raises exception when parsing '#{value}'" do
          expect { @parser.parse(value) }.to raise_exception
        end
      end
    end

    context "CONSTANTS" do
      CONSTANT_POSITIVE_TESTS.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.parse(hash[:value]).should == hash[:expected]
        end
      end

      CONSTANT_NEGATIVE_TESTS.each do |value|
        it "raises exception when parsing '#{value}'" do
          expect { @parser.parse(value) }.to raise_exception
        end
      end
    end

    context "PREDICATES" do
      PREDICATE_POSITIVE_TESTS.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.parse(hash[:value]).should == hash[:expected]
        end
      end

      PREDICATE_NEGATIVE_TESTS.each do |value|
        it "raises exception when parsing '#{value}'" do
          expect { @parser.parse(value) }.to raise_exception
        end
      end
    end

    context "CONNECTIVES" do
      CONNECTIVE_POSITIVE_TESTS.each do |hash|
        it "parses '#{hash[:value]}'" do
          @parser.parse(hash[:value]).should == hash[:expected]
        end
      end
    end

  end

end