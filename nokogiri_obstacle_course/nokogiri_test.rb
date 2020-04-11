require 'minitest/autorun'
require 'nokogiri'
require 'pry'

class NokogiriTest < MiniTest::Test
  # every single test listed below has an associated _detailed_ explanation/answer
  # in the readme at the same level in this repository. 
  
  # if you get stuck on something, find the right spot in the readme.
  # or ping me (josh thompson) and I'll help you out!
  
  ##################################################
  #     these tests all reference shows.xml        #
  ##################################################
  def test_list_all_characters
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
  
  def test_list_all_characters_in_drams
    # Get the characters who performed in Dramas
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))
    
    results = doc.xpath('//dramas//character')
    
    # Desired output:
    # [#(Element:0x3fbfb649df58 { name = "character", children = [ #(Text "John \"Hannibal\" Smith")] }),
       #(Element:0x3fbfb7052c90 { name = "character", children = [ #(Text "Templeton \"Face\" Peck")] }),
       #(Element:0x3fbfb64ec8b0 { name = "character", children = [ #(Text "\"B.A.\" Baracus")] }),
       #(Element:0x3fbfb64f44d4 { name = "character", children = [ #(Text "\"Howling Mad\" Murdock")] })]
    
    assert_equal 4, results.count
    assert_instance_of Nokogiri::XML::Element, results.first
    assert_equal "John \"Hannibal\" Smith", results.first.text
    assert_equal "\"Howling Mad\" Murdock", results.last.text
  end

  def test_get_first_drama_name_in_four_different_ways  
    # Get the first drama name back in _four_ different ways, using css and at_css
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))
    
    results_1 = doc.css('dramas name').first
    results_2 = doc.css('drama name').first
    results_3 = doc.at_css('dramas name')
    results_4 = doc.at_css('drama name')
    
    assert_equal "The A-Team", results_1.text
    assert_equal "The A-Team", results_2.text
    assert_equal "The A-Team", results_3.text
    assert_equal "The A-Team", results_4.text
    
  end
  # - get the names of sitcoms
  # 
  ##################################################
  #     these tests all reference parts.xml        #
  ##################################################
  # 
  # - Get all the tires belonging to 'http://aliceautoparts.com/' using `xpath`
  # - Get all the tires belonging to an `xmlns` value of `http://bobsbikes.com/` using `xpath`
  # - get the first set of tires (alices auto parts) using `css`
  # - get _just the names of the tires_ in an array
  # 
  # ### atom.xml
  ##################################################
  #     these tests all reference atom.xml        #
  ##################################################
  # 
  # - get all titles using `xpath`
  # - get all titles using `css`
  # 
  ##################################################
  #   these tests all reference employees.xml      #
  ##################################################
  # ### employees.xml
  # 
  # - get the full name of the last employee
  # - what is the first employee status?
  # - What is the name of the employee with an inactive status?
  # 
  #####################################################
  # these tests all reference josh_works_archive.html #
  #####################################################
  # ### josh_works_archive.html
  # 
  # - how many links are on the page?
  # - using the `a` css selector, what is the `path` of the last link in the document?
  # - Generate a list of all `href` attributes on the page
  # - Generate an array of strings, representing every single `href` path on the page
  # - Generate array of relative_paths, representing all `href`s in the ARCHIVE portion of the page. Don't include non-archive URLs. (should be 221 results long)

end