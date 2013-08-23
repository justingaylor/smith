require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Smith::Logic::FolParser do

  before(:each) do
    @parser = Smith::Logic::FolParser.new
  end

  describe "#parse" do

    context ":space" do
      it "parses spaces" do
        @parser.space.parse(' ').should == ' '
      end
    end

    context ":space?" do
      it "parses spaces (maybe)" do
        @parser.space?.parse(' ').should == ' '
        @parser.space?.parse('').should == ''
      end
    end

    context ":lparen" do
      it "parses left parentheses" do
        @parser.lparen.parse('(').should == '('
        @parser.lparen.parse('( ').should == '( '
      end
    end

    context ":rparen" do
      it "parses right parentheses" do
        @parser.rparen.parse(')').should == ')'
        @parser.rparen.parse(') ').should == ') '
      end
    end

    context ":comma" do
      it "parses commas" do
        @parser.comma.parse(',').should == ','
        @parser.comma.parse(', ').should == ', '
      end
    end

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
      it "parses variables" do
        @parser.variable.parse("x").should == {:var => "x"}
        @parser.variable.parse("x3").should  == {:var => "x3"}
        @parser.variable.parse("foobar45").should == {:var => "foobar45"}
        @parser.variable.parse("foobar45zw").should == {:var => "foobar45zw"}
      end
    end

    context ":constant" do
      it "parses constants" do
        @parser.constant.parse("G").should == {:const => "G"}
        @parser.constant.parse("JULIA").should == {:const => "JULIA"}
        @parser.constant.parse("JOHNNY5").should == {:const => "JOHNNY5"}
        @parser.constant.parse("JOHNNY2GOOD").should == {:const => "JOHNNY2GOOD"}
      end
    end

    context ":predicate" do
      it "parses predicates" do
        @parser.predicate.parse("Person").should == {:pred => "Person"}
        @parser.predicate.parse("Brother").should == {:pred => "Brother"}
        @parser.predicate.parse("NicePerson").should == {:pred => "NicePerson"}
      end
    end

    context ":connective" do
      it "parses connectives" do
        @parser.connective.parse("&").should == {:and => "&"}
        @parser.connective.parse("|").should == {:or => "|"}
        @parser.connective.parse("=>").should == {:implies => "=>"}
        @parser.connective.parse("<=>").should == {:iff => "<=>"}
        @parser.connective.parse("~").should == {:not => "~"}
        @parser.connective.parse(" ~").should == {:not => "~"}
        @parser.connective.parse("& ").should == {:and => "&"}
        @parser.connective.parse(" | ").should == {:or => "|"}
      end
    end

    context ":arglist" do
      it "parses function and predicate arguments" do
        @parser.arglist.parse("x").should == {:args=>{:var=>"x"}}
        @parser.arglist.parse("x,y").should == {:args=>[{:var=>"x"}, {:var=>"y"}]}
        @parser.arglist.parse("x, y").should == {:args=>[{:var=>"x"}, {:var=>"y"}]}
        @parser.arglist.parse(" x, y").should == {:args=>[{:var=>"x"}, {:var=>"y"}]}
        @parser.arglist.parse(" x, y ").should == {:args=>[{:var=>"x"}, {:var=>"y"}]}
        @parser.arglist.parse(" x, y ").should == {:args=>[{:var=>"x"}, {:var=>"y"}]}
        @parser.arglist.parse("JOE,y").should == {:args=>[{:const=>"JOE"}, {:var=>"y"}]}
        @parser.arglist.parse("JOE,TOM").should == {:args=>[{:const=>"JOE"}, {:const=>"TOM"}]}
        @parser.arglist.parse("JOE,TOM,ANN").should == {
          :args=>[{:const=>"JOE"}, {:const=>"TOM"}, {:const=>"ANN"}]
        }
      end

      it "raises for invalid argument list" do
        expect { @parser.arglist.parse(",") }.to raise_exception
        expect { @parser.arglist.parse(",x") }.to raise_exception
      end
    end

    context ":funcall" do
      it "parses function calls" do
        @parser.funcall.parse("AGE()").should == {:funcall=>{:const=>"AGE"}}
        @parser.funcall.parse("AGE(x)").should == {:funcall=>{:const=>"AGE", :args=>{:var=>"x"}}}
        @parser.funcall.parse("AGE(SUE)").should == {:funcall=>{:const=>"AGE", :args=>{:const=>"SUE"}}}
        @parser.funcall.parse("AGE(x,y)").should == {:funcall=>{:const=>"AGE", :args=>[{:var=>"x"}, {:var=>"y"}]}}
        @parser.funcall.parse("AGE(x,y,z)").should == {
          :funcall=>{:const=>"AGE", :args=>[{:var=>"x"}, {:var=>"y"}, {:var=>"z"}]}
        }
        @parser.funcall.parse("AGE(x,JOE,TIME())").should == {
          :funcall=>{:const=>"AGE", :args=>[{:var=>"x"}, {:const=>"JOE"}, {:funcall=>{:const=>"TIME"}}]}
        }
        @parser.funcall.parse("SORT(SORT(SORT(X3,X2,X1)))").should == {
          :funcall=>{
            :const=>"SORT",
            :args=>{
              :funcall=>{
                :const=>"SORT",
                :args=>{
                  :funcall=>{
                    :const=>"SORT",
                    :args=>[{:const=>"X3"}, {:const=>"X2"}, {:const=>"X1"}]
                  }
                }
              }
            }
          }
        }
      end
    end

    context ":term" do
      it "parses terms" do
        @parser.term.parse("x").should == {:var => "x"}
        @parser.term.parse("x ").should == {:var => "x"}
        @parser.term.parse("x ").should == {:var => "x"}
        @parser.term.parse(" x ").should == {:var => "x"}
        @parser.term.parse("JUSTIN").should == {:const => "JUSTIN"}
        @parser.term.parse(" JUSTIN").should == {:const => "JUSTIN"}
        @parser.term.parse("JUSTIN ").should == {:const => "JUSTIN"}
        @parser.term.parse(" JUSTIN ").should == {:const => "JUSTIN"}
        @parser.term.parse("AGE(x)").should == {:funcall=>{:const=>"AGE", :args=>{:var=>"x"}}}
        @parser.term.parse(" AGE(x)").should == {:funcall=>{:const=>"AGE", :args=>{:var=>"x"}}}
        @parser.term.parse("AGE(x) ").should == {:funcall=>{:const=>"AGE", :args=>{:var=>"x"}}}
        @parser.term.parse(" AGE(x) ").should == {:funcall=>{:const=>"AGE", :args=>{:var=>"x"}}}
      end
    end

    context "fail cases" do
        it "raises exception when parsing invalid values" do
          INVALID_EXAMPLES = [
            "x_", "fo_obar45", "foo bar",          # Invalid variables
            "G_", "DAV__ID", "JUS~TIN",            # Invalid constants/functions
            "Nice_", "Nice_Person", "Nice Person", # Invalid predicates
          ].each do |invalid|
            expect { @parser.parse(invalid) }.to raise_exception
          end
        end
    end

  end

end