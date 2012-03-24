require File.expand_path( File.join( File.dirname(__FILE__), "helper" ) )

Dir.recurse( "." ) do |file|
  filename = File.basename(file)
  if filename[-8..-1] == "_test.rb"
    puts "-"*(file.length+6)
    puts "rspec #{file}"
    puts "-"*(file.length+6)
    system("rspec #{file}")
  end
end