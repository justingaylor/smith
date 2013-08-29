require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Smith::Logic::FolParser do

  before(:each) do
    @parser = Smith::Logic::FolParser.new
  end

  describe "#parse" do

    context "when parsing :space" do
      it "parses valid spaces" do
        @parser.space.parse(' ').should == ' '
      end
      it "doesn't match invalid spaces" do
        expect { @parser.space.parse('') }.to raise_exception
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
        @parser.lparen.parse(' (').should == ' ('
        @parser.lparen.parse(' ( ').should == ' ( '
      end
    end

    context ":rparen" do
      it "parses right parentheses" do
        @parser.rparen.parse(')').should == ')'
        @parser.rparen.parse(') ').should == ') '
        @parser.rparen.parse(' )').should == ' )'
        @parser.rparen.parse(' ) ').should == ' ) '
      end
    end

    context ":comma" do
      it "parses commas" do
        @parser.comma.parse(',').should == ','
        @parser.comma.parse(', ').should == ', '
        @parser.comma.parse(' ,').should == ' ,'
        @parser.comma.parse(' , ').should == ' , '
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

    context ":unary_op" do
      it "parses unary operators" do
        @parser.unary_op.parse("~").should == {:not => "~"}
        @parser.unary_op.parse(" ~").should == {:not => "~"}
        @parser.unary_op.parse("~ ").should == {:not => "~"}
        @parser.unary_op.parse(" ~ ").should == {:not => "~"}
      end
    end

    context ":binary_op" do
      it "parses binary operators" do
        @parser.binary_op.parse("&").should == {:and => "&"}
        @parser.binary_op.parse("& ").should == {:and => "&"}
        @parser.binary_op.parse(" &").should == {:and => "&"}
        @parser.binary_op.parse(" & ").should == {:and => "&"}
        @parser.binary_op.parse("|").should == {:or => "|"}
        @parser.binary_op.parse(" |").should == {:or => "|"}
        @parser.binary_op.parse("| ").should == {:or => "|"}
        @parser.binary_op.parse(" | ").should == {:or => "|"}
        @parser.binary_op.parse("=>").should == {:implies => "=>"}
        @parser.binary_op.parse(" =>").should == {:implies => "=>"}
        @parser.binary_op.parse("=> ").should == {:implies => "=>"}
        @parser.binary_op.parse(" => ").should == {:implies => "=>"}
        @parser.binary_op.parse("<=>").should == {:iff => "<=>"}
        @parser.binary_op.parse(" <=>").should == {:iff => "<=>"}
        @parser.binary_op.parse("<=> ").should == {:iff => "<=>"}
        @parser.binary_op.parse(" <=> ").should == {:iff => "<=>"}
      end

      it "raises for invalid binary operators" do
        expect { @parser.binary_op.parse("~") }.to raise_exception
        expect { @parser.binary_op.parse(" ~") }.to raise_exception
        expect { @parser.binary_op.parse("~ ") }.to raise_exception
        expect { @parser.binary_op.parse(" ~ ") }.to raise_exception
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
        @parser.arglist.parse("JOE").should == {:args=>{:const=>"JOE"}}
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

    context ":predcall" do
      it "parses predicate calls" do
        @parser.predcall.parse("IsTrue()").should == {:predcall=>{:pred=>"IsTrue"}}
        @parser.predcall.parse("Person(x)").should == {:predcall=>{:pred=>"Person", :args=>{:var=>"x"}}}
        @parser.predcall.parse("Person(SUE)").should == {:predcall=>{:pred=>"Person", :args=>{:const=>"SUE"}}}
        @parser.predcall.parse("Loves(x,y)").should == {:predcall=>{:pred=>"Loves", :args=>[{:var=>"x"}, {:var=>"y"}]}}
        @parser.predcall.parse("SameFamily(x,y,z)").should == {
          :predcall=>{:pred=>"SameFamily", :args=>[{:var=>"x"}, {:var=>"y"}, {:var=>"z"}]}
        }
        @parser.predcall.parse("Exist(x,JOE,TIME())").should == {
          :predcall=>{:pred=>"Exist", :args=>[{:var=>"x"}, {:const=>"JOE"}, {:funcall=>{:const=>"TIME"}}]}
        }
        @parser.predcall.parse("Family(SORT(X3,X2,X1))").should == {
          :predcall=>{
            :pred=>"Family",
            :args=>{
              :funcall=>{
                :const=>"SORT",
                :args=>[{:const=>"X3"}, {:const=>"X2"}, {:const=>"X1"}]
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

    context ":binary_clause" do
      it "parses binary (connective) clauses" do
        @parser.binary_clause.parse("Person(JIM) & Person(DAN)").should == {
          :clause => {
            :left => {:predcall=>{:pred=>"Person", :args=>{:const=>"JIM"}}},
            :and => "&",
            :right => {:predcall=>{:pred=>"Person", :args=>{:const=>"DAN"}}}
          }
        }
        @parser.binary_clause.parse("Friend(x,y) <=> Friend(y,x)").should == {
          :clause => {
            :left => {:predcall=>{:pred=>"Friend", :args=>[{:var=>"x"},{:var=>"y"}]}},
            :iff => "<=>",
            :right => {:predcall=>{:pred=>"Friend", :args=>[{:var=>"y"},{:var=>"x"}]}}
          }
        }
      end
    end

    context ":unary_clause" do
      it "parses unary clauses" do
        @parser.unary_clause.parse("~Person(GODZILLA)").should == {
          :not => "~",
          :formula => {
            :predcall => {:pred=>"Person", :args=>{:const=>"GODZILLA"}}
          }
        }
        @parser.unary_clause.parse("~ ( Person(GODZILLA) ) ").should == {
          :not => "~",
          :formula => {
            :predcall => {:pred=>"Person", :args=>{:const=>"GODZILLA"}}
          }
        }
        @parser.unary_clause.parse("~(Person(GODZILLA) | Person(MOTHRA))").should == {
          :not => "~",
          :formula => {
            :clause => {
              :left => {:predcall=>{:pred=>"Person", :args=>{:const=>"GODZILLA"}}},
              :or => "|",
              :right => {:predcall=>{:pred=>"Person", :args=>{:const=>"MOTHRA"}}}
            }
          }
        }
      end
    end

    context ":formula" do
      it "parses first-order logic formulas" do
        @parser.formula.parse("Loves(x,y)").should == {
          :formula => {
            :predcall => {:pred=>"Loves", :args=>[{:var=>"x"}, {:var=>"y"}]}
          }
        }
        @parser.formula.parse("Born(x,NOW())").should == {
          :formula => {
            :predcall => {
              :pred => "Born",
              :args=>[{:var=>"x"}, {:funcall=>{:const=>"NOW"}}]
            }
          }
        }
        @parser.formula.parse("Person(JOE) & Person(ANN)").should == {
          :formula => {
            :clause => {
              :left => {:predcall=>{:pred=>"Person", :args=>{:const=>"JOE"}}},
              :and => "&",
              :right => {:predcall=>{:pred=>"Person", :args=>{:const=>"ANN"}}}
            }
          }
        }
        @parser.formula.parse("~Person(GODZILLA) & Person(FUJIMOTO)").should == {
          :formula => {
            :not => "~",
            :formula => {
              :clause => {
                :left => {:predcall=>{:pred=>"Person", :args=>{:const=>"GODZILLA"}}},
                :and => "&",
                :right => {:predcall=>{:pred=>"Person", :args=>{:const=>"FUJIMOTO"}}}
              }
            }
          }
        }
        @parser.formula.parse("(True() & False())").should == {
          :formula => {
            :clause => {
              :left => {:predcall=>{:pred=>"True"}},
              :and => "&",
              :right => {:predcall=>{:pred=>"False"}}
            }
          }
        }
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