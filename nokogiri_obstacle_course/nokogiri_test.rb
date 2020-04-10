require 'minitest/autorun'
require 'nokogiri'
require 'pry'

class NokogiriTest < MiniTest::Test
  
  
  def test_shows_xml_lists_all_characters
    # list of all the characters in all the shows in this document
    
    # Unless otherwise noted, every file we'll be reading is located
    # within the /docs_to_parse directory. 
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))
    
    results = doc.xpath('//character')
    # remember, use pry in here to inspect your results. Use 
    # the #to_a method to easily see in your terminal what sort of 
    # results you're getting back from Nokogiri
    
    assert_equal 9, results.count
    assert_instance_of Nokogiri::XML::Element, results.first
    assert_equal "Al Bundy", results.first.text
    assert_equal "\"Howling Mad\" Murdock", results.last.text
  end
  
  
  ### shows.xml

  # - list of all the characters in all the shows in this document
  # - Get the characters who performed in Dramas
  # - Get the first drama name back in _four_ different ways
  # - get the names of sitcoms
  # 
  # ### parts.xml
  # 
  # - Get all the tires belonging to 'http://aliceautoparts.com/' using `xpath`
  # - Get all the tires belonging to an `xmlns` value of `http://bobsbikes.com/` using `xpath`
  # - get the first set of tires (alices auto parts) using `css`
  # - get _just the names of the tires_ in an array
  # 
  # ### atom.xml
  # 
  # - get all titles using `xpath`
  # - get all titles using `css`
  # 
  # 
  # ### employees.xml
  # 
  # - get the full name of the last employee
  # - what is the first employee status?
  # - What is the name of the employee with an inactive status?
  # 
  # ### josh_works_archive.html
  # 
  # - how many links are on the page?
  # - using the `a` css selector, what is the `path` of the last link in the document?
  # - Generate a list of all `href` attributes on the page
  # - Generate an array of strings, representing every single `href` path on the page
  #  - Generate array of relative_paths, representing all `href`s in the ARCHIVE portion of the page. Don't include non-archive URLs. (should be 221 results long)

end