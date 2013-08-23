#------------------------
# VALID EXAMPLES
#------------------------

VARIABLE_VALID_EXAMPLES = [
  {:value => "x",          :expected => {:var => "x"}},
  {:value => "x3",         :expected => {:var => "x3"}},
  {:value => "foobar45",   :expected => {:var => "foobar45"}},
  {:value => "foobar45zw", :expected => {:var => "foobar45zw"}}
]

CONSTANT_VALID_EXAMPLES = [
  {:value => "G",       :expected => {:const => "G"}},
  {:value => "JULIA",   :expected => {:const => "JULIA"}},
  {:value => "JOHNNY5", :expected => {:const => "JOHNNY5"}}
]

PREDICATE_VALID_EXAMPLES = [
  {:value => "Person",     :expected => {:pred => "Person"}},
  {:value => "Brother",    :expected => {:pred => "Brother"}},
  {:value => "NicePerson", :expected => {:pred => "NicePerson"}}
]

CONNECTIVE_VALID_EXAMPLES = [
  {:value => "&",   :expected => {:and => "&"}},
  {:value => "|",   :expected => {:or => "|"}},
  {:value => "=>",  :expected => {:implies => "=>"}},
  {:value => "<=>", :expected => {:iff => "<=>"}},
  {:value => "~",   :expected => {:not => "~"}}
]

TERM_VALID_EXAMPLES = [
  {:value => "x",        :expected => {:var => "x"}},
  {:value => "x ",       :expected => {:var => "x"}},
  {:value => " x",       :expected => {:var => "x"}},
  {:value => " x ",      :expected => {:var => "x"}},
  {:value => "JUSTIN ",  :expected => {:const => "JUSTIN"}},
  {:value => " JUSTIN",  :expected => {:const => "JUSTIN"}},
  {:value => " JUSTIN ", :expected => {:const => "JUSTIN"}},
  {:value => "AGE(x)",   :expected => {:pred => "AGE(x)"}},
  {:value => " AGE(x)",  :expected => {:pred => "AGE(x)"}},
  {:value => "AGE(x) ",  :expected => {:pred => "AGE(x)"}},
  {:value => " AGE(x) ", :expected => {:pred => "AGE(x)"}}
]

#------------------------
# INVALID EXAMPLES
#------------------------

INVALID_EXAMPLES = [
  "x_", "fo_obar45", "foo bar",          # Invalid variables
  "G_", "DAV__ID", "JUS~TIN",            # Invalid constants/functions
  "Nice_", "Nice_Person", "Nice Person", # Invalid predicates
]