require 'minitest/autorun'

class FooTest < MiniTest::Test
  def test_read_4th_character
    contents = File.read('refactoring/test/data.txt')
    assert_equal 'd', contents[3,1]
  end
  
  def test_read_4th_content_is_2
    contents = File.read('refactoring/test/data.txt')
    assert_equal 'dm', contents[3,2]
  end
  
  def test_read_with_length_specified
    contents = File.read('refactoring/test/data.txt', 15)
    assert_equal 'Bradman 99.', contents
  end
end