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
    skip
    # list of all the characters in all the shows in this document

    # every file we'll be reading is locate within the /docs_to_parse directory.
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))
    # require "pry"; binding.pry
    # Open up this 'shows.xml' file in your editor, so you can be "reading" the 
    # html as you parse it with Nokogiri.
    
    # results = doc.xpath('//character')
    results = doc.css('character') # remember, css/xpath selectors are the same
    
    # remember, use pry in here to inspect your results. Use
    # the #to_a method to easily see in your terminal what sort of
    # results you're getting back from Nokogiri, I.E. call:
    # results.to_a 
    # or
    # doc.xpath('//character')
    
    # Expected results will look something like this: 
    #(Element:0x3fccb9994394 { name = "character", children = [ #(Text "Al Bundy")] }),
    #(Element:0x3fccb9d65f68 { name = "character", children = [ #(Text "Bud Bundy")] }),
    #(Element:0x3fccb9d65ba8 { name = "character", children = [ #(Text "Marcy Darcy")] }),
    #(Element:0x3fccb9d65810 { name = "character", children = [ #(Text "Larry Appleton")] }),
    #(Element:0x3fccb9d65360 { name = "character", children = [ #(Text "Balki Bartokomous")] }),
    #(Element:0x3fccb9d64fb4 { name = "character", children = [ #(Text "John \"Hannibal\" Smith")] }),
    #(Element:0x3fccb9d64bf4 { name = "character", children = [ #(Text "Templeton \"Face\" Peck")] }),
    #(Element:0x3fccb9d64884 { name = "character", children = [ #(Text "\"B.A.\" Baracus")] }),
    #(Element:0x3fccb9d64370 { name = "character", children = [ #(Text "\"Howling Mad\" Murdock")] })]]

    assert_equal 9, results.count
    assert_instance_of Nokogiri::XML::Element, results.first
    assert_equal "Al Bundy", results.first.text
    assert_equal "\"Howling Mad\" Murdock", results.last.text
  end

  def test_list_all_characters_in_dramas
    skip
    # Get the characters who performed in Dramas
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))

    results = doc.css('dramas character')

    # Desired output:
    # [(Element:0x3fbfb649df58 { name = "character", children = [ #(Text "John \"Hannibal\" Smith")] }),
    #  (Element:0x3fbfb7052c90 { name = "character", children = [ #(Text "Templeton \"Face\" Peck")] }),
    #  (Element:0x3fbfb64ec8b0 { name = "character", children = [ #(Text "\"B.A.\" Baracus")] }),
    #  (Element:0x3fbfb64f44d4 { name = "character", children = [ #(Text "\"Howling Mad\" Murdock")] })]

    assert_equal 4, results.count
    assert_instance_of Nokogiri::XML::Element, results.first
    assert_equal "John \"Hannibal\" Smith", results.first.text
    assert_equal "\"Howling Mad\" Murdock", results.last.text
  end

  def test_get_first_drama_name_in_four_different_ways
    skip
    # Get the first drama name back in _four_ different ways, 
    # using .css and .at_css
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))

    # results_1 = doc.css('dramas name').first
    # results_2 = doc.css('drama name').first
    # results_3 = doc.at_css('dramas name')
    # results_4 = doc.at_css('drama name')

    assert_equal "The A-Team", results_1.text
    assert_equal "The A-Team", results_2.text
    assert_equal "The A-Team", results_3.text
    assert_equal "The A-Team", results_4.text
  end

  def test_get_the_names_of_all_sitcoms
    skip
    # get the names of sitcoms using css
    doc = Nokogiri::XML(File.open('docs_to_parse/shows.xml'))

    # results = your code here
    # if stuck, look at the readme for an explainer

    assert_equal 2, results.count
    assert_includes results.map {|n| n.text }, "Perfect Strangers"
    assert_includes results.map {|n| n.text }, "Married with Children"
  end

  ##################################################
  #     these tests all reference parts.xml        #
  ##################################################
  def test_get_all_tires_belonging_to_aliceautoparts_using_xpath
    skip
    # might be worth skipping this test. I've not seein this xml name-space thing
    # used in the wild yet. 
    
    # using xpath, get tires with the XML namespace value `http://alicesautoparts.com/`
    doc = Nokogiri::XML(File.open('docs_to_parse/parts.xml'))
    # Open up this 'parts.xml' file in your editor, so you can be "reading" the 
    # html as you parse it with Nokogiri.
    
    results = doc.css('xmlns|tire', xmlns: "http://alicesautoparts.com/")

    assert_equal 3, results.count
    assert_includes results.map { |n| n.text }, "all weather"
    assert_includes results.map { |n| n.text }, "studded"
    assert_includes results.map { |n| n.text }, "extra wide"
  end

  def test_get_all_tires_belonging_to_bobsbikes_using_xpath
    skip
    # using xpath, get tires with the XML namespace value `http://bobsbikes.com/`
    doc = Nokogiri::XML(File.open('docs_to_parse/parts.xml'))

    # results = your code here

    assert_equal 2, results.count
    assert_includes results.map { |n| n.text }, "street"
    assert_includes results.map { |n| n.text }, "mountain"
  end

  def test_get_tires_from_aliceautoparts_using_css
    skip
    # using css, get first set of tires (alices auto parts)
    doc = Nokogiri::XML(File.open('docs_to_parse/parts.xml'))

    # results = doc.css('xmlns|tire', xmlns: 'http://alicesautoparts.com/')

    assert_equal 3, results.count
    assert_includes results.map { |n| n.text }, "all weather"
    assert_includes results.map { |n| n.text }, "studded"
    assert_includes results.map { |n| n.text }, "extra wide"
  end

  def test_get_just_names_of_tires_in_an_array
    skip
    # get _just the names of the tires_ in an array
    doc = Nokogiri::XML(File.open('docs_to_parse/parts.xml'))

    # results = doc.css('xmlns|tire', xmlns: "http://alicesautoparts.com/").map { |n| n.text }

    expected = ['all weather', 'studded', 'extra wide']
    assert_equal results, expected
  end

  ##################################################
  #     these tests all reference atom.xml        #
  ##################################################
  def test_get_all_titles_using_xpath
    skip
    # get all titles using `xpath`
    doc = Nokogiri::XML(File.open('docs_to_parse/atom.xml'))
    # Open up this 'atom.xml' file in your editor, so you can be "reading" the 
    # html as you parse it with Nokogiri.

    # results = your code here

    expected = ['Example Feed', 'Atom-Powered Robots Run Amok']
    assert_equal 2, results.count
    assert_equal expected, results.map { |n| n.text }
  end

  def test_get_all_titles_using_css
    skip
    # get all titles using css
    doc = Nokogiri::XML(File.open('docs_to_parse/atom.xml'))

    # results = your code here

    expected = ['Example Feed', 'Atom-Powered Robots Run Amok']
    assert_equal 2, results.count
    assert_equal expected, results.map { |n| n.text }
  end

  ##################################################
  #   these tests all reference employees.xml      #
  ##################################################
  def test_full_name_last_employee
    skip
    # get the full name of the last employee
    doc = Nokogiri::XML(File.open('docs_to_parse/employees.xml'))
    # Open up this 'employees.xml' file in your editor, so you can be "reading" the 
    # html as you parse it with Nokogiri.

    # results = your code here

    assert_equal "Jerry Lewis", results
  end

  def test_status_first_employee
    skip
    # what is the first employee status?
    doc = Nokogiri::XML(File.open('docs_to_parse/employees.xml'))

    # results = your code here

    assert_equal "active", results
  end

  def test_name_of_inactive_employee
    skip
    # What is the name of the employee with an inactive status?
    doc = Nokogiri::XML(File.open('docs_to_parse/employees.xml'))

    # results = your code here

    assert_equal "Jerry Lewis", results
  end

  #####################################################
  # these tests all reference josh_works_archive.html #
  #####################################################
  def test_total_link_count
    skip
    # how many links are on the page?
    doc = Nokogiri::XML(File.open('docs_to_parse/josh_works_archive.html'))
    # Open up this 'josh_works_archive.html' file in your editor, so you can be "reading" the 
    # html as you parse it with Nokogiri. Also, open it in your browser, so you 
    # can wrap your head around it all.

    # results = your code here

    assert_equal 226, results.count
  end

  def test_get_path_of_last_link
    skip
    # using the `a` css selector, what is the `path` of the last link in the document?
    doc = Nokogiri::XML(File.open('docs_to_parse/josh_works_archive.html'))

    # result = your code here

    assert_equal '/three-ways-to-decide-what-to-be-when-you-grow-up', result
  end

  def test_list_all_hrefs_on_page
    skip
    # Generate a list of all `href` attributes on the page
    # each attribute should be a Nokogiri::XML::Attr
    doc = Nokogiri::XML(File.open('docs_to_parse/josh_works_archive.html'))

    # results = your code here

    # results should look like:
    # [(Attr:0x3fc00bcf596c { name = "href", value = "/" }),
    #  (Attr:0x3fc00bcf5930 { name = "href", value = "/about" }),
    #  (Attr:0x3fc00bcf58f4 { name = "href", value = "/archive" }),
    #  (Attr:0x3fc00bcf58b8 { name = "href", value = "/turing" }),
    #  (Attr:0x3fc00bcf587c { name = "href", value = "/office-hours" }), etc

    assert_equal 226, results.count
    assert_instance_of Nokogiri::XML::Attr, results.first
  end

  def test_array_of_strings_of_every_path_on_page
    skip
    # Generate an array of strings, representing every single `href` path on the page
    doc = Nokogiri::XML(File.open('docs_to_parse/josh_works_archive.html'))

    # results = your code here

    assert_equal 226, results.count
    assert_includes results, "/three-ways-to-decide-what-to-be-when-you-grow-up"
    assert_includes results, "/2018-review"
    assert_includes results, "/troubleshooting-chinese-character-sets-in-mysql"
    assert_includes results, "/test-rake-tasks-in-rails"
    assert_includes results, "/finding-an-edge"
    assert_includes results, "/developer-workflow"
  end

  def test_get_path_for_first_link_that_has_sibling_element_of_time_class
    skip
    # find the first link that has a `time` class associated with it.
    # traverse the DOM from that time class to the associated URL
    doc = Nokogiri::XML(File.open('docs_to_parse/josh_works_archive.html'))

    # result = your code here

    assert_equal '/2019-review', result
  end

  def test_list_all_paths_of_links_in_archive_portion_of_page
    skip
    # Generate array of relative_paths, representing all `href`s in the ARCHIVE portion of the page.
    # Don't include non-archive URLs. (should be 221 results long)
    doc = Nokogiri::XML(File.open('docs_to_parse/josh_works_archive.html'))

    # results = your code here

    assert_equal 221, results.count
    refute_includes results, '/about'
    refute_includes results, '/archive'
    refute_includes results, '/office_hours'
    assert_includes results, '/2019-review'
    assert_includes results, '/block-value'
  end

  #####################################################
  #       time to scrape the web with Nokogiri        #
  #####################################################
  require 'open-uri'

  def test_finds_first_comment
    skip
    # doc = Nokogiri::HTML(open("https://news.ycombinator.com/item?id=22800136"))

    # result = your code here

    assert_instance_of Nokogiri::XML::Element, result
    assert_equal "comment", result.attributes['class'].value
    assert_equal 4, result.children.css('a[href]').count

  end

  # using hn_jobs_thread create an array of all links in the comments
  def test_finds_first_links_in_comments
    skip
    # doc = Nokogiri::HTML(open("https://news.ycombinator.com/item?id=22800136"))

    # results = your code here

    first_links = [
      "https://paulstamatiou.com/",
      "https://paulstamatiou.com/getting-started-with-security-keys/",
      "https://paulstamatiou.com/building-a-windows-10-lightroom-photo-editing-pc/",
      "https://paulstamatiou.com/stuff-i-use/",
      "https://paulstamatiou.com/about-this-website/",
      "https://tkainrad.dev",
      "https://tkainrad.dev/posts/managing-my-personal-knowledge-base/",
      "https://tkainrad.dev/posts/setting-up-linux-workstation/",
      "https://tkainrad.dev/posts/using-hugo-gitlab-pages-and-cloudflare-to-create-and-run-this-website/"
    ]

    assert_instance_of Array, results
    assert_equal first_links, results[0..8]
  end
end
