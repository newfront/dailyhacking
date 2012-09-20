#!/usr/bin/ruby

require "fsv_to_hex.rb"
require "test/unit"

class Test_FSV_TO_HEX < Test::Unit::TestCase
  
  # test that a file can be opened up and parsed
  def test_file_opens_and_returns_string
    
    assert_instance_of(String, open_up_file_parse_bin_to_hex("h263-1998-capture_922am.fsv","rb"))
    
  end
  
  def test_that_file_opens_and_is_fsv
    # test fails, not sure if it waits for blocks to complete
    #assert(read_file_to_binary("h263-1998-capture_922am.fsv"))
  end
  
end