Gem::Specification.new do |s|
  s.name        = 'smith'
  s.version     = '0.0.1'
  s.date        = '2013-08-14'
  s.summary     = "The Smith Agent Framework"
  s.description = "A framework for rapidly prototyping AI agents"
  s.authors     = ["Justin Gaylor"]
  s.email       = 'justin.gaylor@gmail.com'
  s.files       = ["Gemfile", "lib/smith.rb"]
  s.files      += Dir.glob("lib/**/*.rb")                                           # Source Files
  s.files      += Dir.glob("features/**/*.feature") + Dir.glob("features/**/*.rb")  # Cucumber features
  s.homepage    = 'https://github.com/justingaylor/smith'
  s.license     = 'MIT'

  #--------------------
  # Gem dependencies
  #--------------------

  # For writing parser for First-Order Logic expressions
  s.add_runtime_dependency 'parslet'

  # Testing & Debugging
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end