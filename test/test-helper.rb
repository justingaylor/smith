$BASE_DIR = File.expand_path( File.join( File.dirname(__FILE__), ".." ) )
$LIB_DIR  = File.join( $BASE_DIR, "lib" )
$TEST_DIR  = File.join( $BASE_DIR, "test" )

$LOAD_PATH.unshift($LIB_DIR)

class Dir
  #---------------------------------------------------------
  # Method: recurse
  # Description:  Executes a block for every file in the
  #   current directory tree.
  # Parameters: 
  #   dir - The directory to start from
  #   skip_hidden - Flag for whether to recurse into hidden 
  #     folders or not
  #   &block - The block passed by the caller which is
  #     applied to each entry in the directory tree
  #---------------------------------------------------------
  def self.recurse( dir, skip_hidden=true, &block )
    absolute_dir = File.expand_path( dir )
    entries = Dir.entries( absolute_dir )
  
    # Remove unnecessary entries and hidden directories (if requested)
    entries.reject! { |e| e == ".." or 
                          e == "." or
                          skip_hidden and File.directory?(e) and e[0] == "." }

    # Iterate through the entries in this directory
    # If an entry is a file, execute our block else recurse
    entries.each do |entry|
      absolute_path = File.expand_path( "#{absolute_dir}/#{entry}" )
      if File.file? absolute_path
        yield( absolute_path )
      else
        self.recurse( absolute_path, skip_hidden, &block)
      end
    end
  end
end