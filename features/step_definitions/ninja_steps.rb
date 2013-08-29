Given /^the ninja has a ([a-z]*) level black\-belt$/ do |belt_level|
  @ninja=Ninja.new belt_level
end

When /^attacked by [a\s]*(.*)$/ do |opponent|
  @actions=@ninja.attacked_by(opponent)
end

Then /^the ninja should (.*)$/ do |expected_action|
  @actions.include?(expected_action).should be_true
end