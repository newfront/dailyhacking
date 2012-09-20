#!/usr/bin/ruby

require "tools/hex_to_bin_converter.rb"
require "test/unit"

class TestHexToBinConverter < Test::Unit::TestCase
  
  # test simple use case,
  # if user is actually providing the intended information, which is Array, and "to_bin" or "to_hex"
  def test_hex_to_bin_lookup
    
    # simple cases
    assert_equal("00000001", NumberFormat.hex_or_bin_conversion(["01"],"to_bin"))
    assert_equal("11100111", NumberFormat.hex_or_bin_conversion(["E7"],"to_bin"))
    
  end
  
  def test_forgot_second_parameter
    # user forgot second parameter
    # should pass
    assert_equal("00010000", NumberFormat.hex_or_bin_conversion(["10"]))
    assert_equal("01111110", NumberFormat.hex_or_bin_conversion(["7e"]))
  end
  
  def test_forgot_array_element_but_provided_string
    # user forgot an array, and passed a string
    assert_equal("11111111", NumberFormat.hex_or_bin_conversion("FF"))
    assert_equal("1010101111001101", NumberFormat.hex_or_bin_conversion("AbCd"))
  end
  
  def test_parameter_one_nil
    
    assert_raise( ArgumentError ) { NumberFormat.hex_or_bin_conversion()}
    
  end
  
  def test_parameter_failure
    #assert_equal("SCOTT", NumberFormat.hex_or_bin_conversion("FGG"))
  end
  
end

# Available Assertions
# assert(boolean,[message]) => true if boolean
# assert_equal(expected, actual, [message]) => true if expected == actual
# assert_not_equal(expected, actual, [message]) => true, if expected != actual
# assert_match(pattern,string,[message]) => true, if string =~ pattern
# assert_no_match(pattern,string,[message]) => true, if string =~ pattern
# assert_nil( object, [message]) => true, if object == nil
# asert_not_nil(object, [message]) => true, if object != nil
# assert_in_delta( expected_float, actual_float, delta, [message]) => true if (actual_float - expected_float).abs <= delta
# assert_instance_of(class, object, [message]) => true, if object.class == class
# assert_kind_of(class, object, [message]) => true, if object.kind_of?(class)
# assert_same(expected, actual, [message]) => true, is actual.equal?(expected)
# assert_not_same(expected, actual, [message]) => true, if !actual.equal?(expected)
# assert_raise(Exception,...) { block }
# assert_nothing_raised(Exception, ...) { block }
# assert_throws(expected_symbol,[message]) { block }
# assert_nothing_thrown([message]) { block }
# assert_respond_to(object,method,[message]) => true, if the object can respond to the given method
# assert_send( send_array,[message]) => true, if the method sent to the object with the given arguments returns true
# assert_operator(object1, operator, object2, [message]) => compares the two objects with the given operator, passes if true