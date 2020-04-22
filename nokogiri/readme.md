_This repo exists because I worked through [THE BEGINNER’S GUIDE: Scraping in Ruby Cheat Sheet](https://medium.com/@LindaVivah/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c), and step 10 made a HUGE leap with nokogiri knowledge, and I felt skipped a huge piece I didn't understand. I made the exercise work, but I still didn't know enough about nokogiri to go solve novel problems with it._

_This collection of exercises will *quickly* get you comfortable enough in nokogiri to do fascinating things quickly using it_


_Questions or comments? hit me up in Turing's slack (`@josh_t`), open a git issue, etc._


I can add explanation later.

To work through same exercises the Nokogiri docs give on [Searching a XML/HTML document](https://nokogiri.org/tutorials/searching_a_xml_html_document.html)

Clone down this repo. 

```
$ git clone git@github.com:josh-works/intermediate_ruby_obstacle_course.git
$ cd intermediate_ruby_obstacle_courses/nokogiri
$ gem install nokogiri
```

At same relative path as this `readme`, run:

```
$ ruby nokogiri_test.rb
```

You should see a bunch of skips:

![starting!](/images/scraping_18.jpg)

Next, open up your "workspace". This will be the nokogiri test file, and the document we're working on, both easily visible so you can see what you're working on:

Here's how I would recommend "setting up" these exercises:
1. Make sure you can easily see in your editor the document we're working on parsing
2. Make sure you can easily see the _huge_ output that you'll be getting in Pry as practicing/figuring this all out.

![ready to work through exercises](/images/scraping_30.jpg)


Unskip the first test, and make it pass. Work through this blog post as you work through each test; this readme and the test file go hand-in-hand.

For now, I've included the answers (commented out). Delete them and see if you can make the tests pass without any assistance.

_I wrote each test approximately as I discovered things and wrote the tests. Here's my notes from that process_

# test_list_all_characters
 
 These exercises are working through the examples here: [Basic Searching (nokogiri docs)](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#basic-searching)

in the prompt:

```ruby
require 'nokogiri'
# => true
> @doc = Nokogiri::XML(File.open("shows.xml"))
# lots of output
> @doc.xpath("//character")
# => ["<character>Al Bundy</character>",
#    "<character>Bud Bundy</character>",
#    "<character>Marcy Darcy</character>",
#    "<character>Larry Appleton</character>",
#    "<character>Balki Bartokomous</character>",
#    "<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

Desired outcome:

```
# => ["<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

```

[#<Nokogiri::XML::Element:0x3fe36f0c7c30 name="character" children=[#<Nokogiri::XML::Text:0
x3fe36e97a6d0 "John \"Hannibal\" Smith">]>, #<Nokogiri::XML::Element:0x3fe36f0a6d50 name="ch
aracter" children=[#<Nokogiri::XML::Text:0x3fe36f08e1b0 "Templeton \"Face\" Peck">]>, #<Nokogiri::XML::Element:0x3fe36e96f08c name="character" children=[#<Nokogiri::XML::Text:0x
3fe36f07afd4 "\"B.A.\" Baracus">]>, #<Nokogiri::XML::Element:0x3fe36e457a90 name="character" children=[#<Nokogiri::XML::Text:0x3fe36e452428 "\"Howling Mad\" Murdock">]>]

```

This is how it looked in Pry:

![rather difficult to read](/images/scraping_01.jpg)

Here's the above line, spaced out a bit better:

```
[#<Nokogiri::XML::Element:0x3fe36f0c7c30 name="character" children=
    [#<Nokogiri::XML::Text:0x3fe36e97a6d0 "John \"Hannibal\" Smith">]>, 
 #<Nokogiri::XML::Element:0x3fe36f0a6d50 name="character" children=
    [#<Nokogiri::XML::Text:0x3fe36f08e1b0 "Templeton \"Face\" Peck">]>, 
 #<Nokogiri::XML::Element:0x3fe36e96f08c name="character" children=
    [#<Nokogiri::XML::Text:0x3fe36f07afd4 "\"B.A.\" Baracus">]>, 
 #<Nokogiri::XML::Element:0x3fe36e457a90 name="character" children=
    [#<Nokogiri::XML::Text:0x3fe36e452428 "\"Howling Mad\" Murdock">]>
]
```

So then I went hunting down the docs to see if I could reliably print the output of a nokogiri command, and it be reasonable!

(This didn't seem too unreasonable...)

None of this worked:

```ruby
p @doc.xpath("//character")
@doc.xpath("//character").to_s
puts @doc.xpath("//character")
@doc.xpath("//character").join("\n")
```

I messed with my `~/.pryrc`, cuz I'd had an ignored deprecation warnings for a while. 

Looked through [tons of Pry git issues...](https://github.com/pry/pry/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)

Finally, I got this output:

![so much more readable](/images/scraping_02.jpg)

All I needed to do was call `.to_a` on a Nokogiri object!!!

Makes it so much readable. 

Back to the original question:

> list of all the characters in all the shows in this document

Desired output:

```
# => ["<character>Al Bundy</character>",
#    "<character>Bud Bundy</character>",
#    "<character>Marcy Darcy</character>",
#    "<character>Larry Appleton</character>",
#    "<character>Balki Bartokomous</character>",
#    "<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

Here's the bit of the XML that we want to grab:

![we want these lines](/images/scraping_03.jpg)

We can "grab" every single object with a `character` key:

```
@doc.xpath("//character")
=> [#(Element:0x3fbfb65e8e6c { name = "character", children = [ #(Text "Al Bundy")] }),
 #(Element:0x3fbfb685fce0 { name = "character", children = [ #(Text "Bud Bundy")] }),
 #(Element:0x3fbfb70af800 { name = "character", children = [ #(Text "Marcy Darcy")] }),
 #(Element:0x3fbfb64f0104 { name = "character", children = [ #(Text "Larry Appleton")] }),
 #(Element:0x3fbfb703f76c { name = "character", children = [ #(Text "Balki Bartokomous")] }),
 #(Element:0x3fbfb649df58 { name = "character", children = [ #(Text "John \"Hannibal\" Smith")] }),
 #(Element:0x3fbfb7052c90 { name = "character", children = [ #(Text "Templeton \"Face\" Peck")] }),
 #(Element:0x3fbfb64ec8b0 { name = "character", children = [ #(Text "\"B.A.\" Baracus")] }),
 #(Element:0x3fbfb64f44d4 { name = "character", children = [ #(Text "\"Howling Mad\" Murdock")] })]
```

Done. My output looks slightly different than the Nokogiri docs, but that's OK with me.

# test_list_all_characters_in_dramas

> Get the 4 characters who performed in Dramas

Desired output:

```
# => ["<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

OK, this means we want to look in the "dramas" node? tree branch? xml-thing? and grab the characters it contains:

![we want this](/images/scraping_04.jpg)

```ruby
> @doc.xpath("//dramas//character")
# don't forget that you need to call .to_a to inspect the contents nicely
=> [#(Element:0x3fbfb649df58 { name = "character", children = [ #(Text "John \"Hannibal\" Smith")] }),
 #(Element:0x3fbfb7052c90 { name = "character", children = [ #(Text "Templeton \"Face\" Peck")] }),
 #(Element:0x3fbfb64ec8b0 { name = "character", children = [ #(Text "\"B.A.\" Baracus")] }),
 #(Element:0x3fbfb64f44d4 { name = "character", children = [ #(Text "\"Howling Mad\" Murdock")] })]
```

My output differs slightly from the output listed in the docs. I'm not sure why, but I'm going to keep moving forward!


# test_get_first_drama_name_in_four_different_ways

> Get the first drama name back in four different ways

Desired result:

```
"<name>The A-Team</name>"
```

```ruby
@doc.css("dramas name").first
@doc.css("drama name").first
@doc.at_css("dramas name")
@doc.at_css("drama name")
=> #(Element:0x3fbfb640b388 { name = "name", children = [ #(Text "The A-Team")] })
```

![using both "keys" in the xml doc](/images/scraping_05.jpg)

# test_get_the_names_of_all_sitcoms

> get the names of all sitcoms

Desired output:

```
# => ["<name>Married with Children</name>", 
#     "<name>Perfect Strangers</name>"]
```

Using a CSS Selector!

```ruby
@doc.css('sitcoms name')
@doc.css('sitcom name')  # both of these work
```

# test_get_all_tires_belonging_to_aliceautoparts_using_xpath

 Now the tutorial jumps to using `parts.xml`

In your terminal:

```
$ pry
```

Require `nokogiri` and load the intended XML file:

```ruby
require 'nokogiri'
=> true
@doc = Nokogiri::XML(File.read("parts.xml"))
=> #(Document:0x3fdf9a87bcfc {
  name = "document",
  children = [ # on and on and on
```




> Get all the tires belonging to 'http://aliceautoparts.com/'

Intended result:

```ruby
# => ["<tire>all weather</tire>",
#    "<tire>studded</tire>",
#    "<tire>extra wide</tire>"]
```

```ruby
@doc.xpath('//car:tire', 'car' => 'http://alicesautoparts.com/')
```

The results here are nearly unbelievable, that the intended results and actual results are the same!

Here's what I got:

```
>> @doc.xpath('//car:tire', 'car' => 'http://alicesautoparts.com/').to_a
=> [#(Element:0x3fdf9a829038 {
   name = "tire",
   namespace = #(Namespace:0x3fdf9a00c774 { href = "http://alicesautoparts.com/" }),
   children = [ #(Text "all weather")]
   }),
 #(Element:0x3fdf99ed16fc {
   name = "tire",
   namespace = #(Namespace:0x3fdf9a00c774 { href = "http://alicesautoparts.com/" }),
   children = [ #(Text "studded")]
   }),
 #(Element:0x3fdf9a497b2c {
   name = "tire",
   namespace = #(Namespace:0x3fdf9a00c774 { href = "http://alicesautoparts.com/" }),
   children = [ #(Text "extra wide")]
   })]
```

my output is colorized, and don't forget to call `to_a` on the results of every `nokogiri` call, to get the results formatted nicely.

If you're like me, you might try re-building the above line from scratch, and might find that this line doesn't work:

```ruby
>> @doc.xpath('//car:tire', 'car' => 'http://alicesautoparts.com')
#  @doc.xpath('//car:tire', 'car' => 'http://alicesautoparts.com/') 
# missing the trailing slash. :facepalm:
=> []
```

In fact, you might wonder what all this crap is.

The word `car` doesn't exist in the document! Why is `car` used twice in this xpath call?

Oh. My. gosh. I just burnt 30 minutes confused on some stupid XML thing; no one uses XML anymore, but in the `parts.xml` document, it includes the `xmlns` keyword. 

`xmlns` stands for `XML Name Space`. ([wikipedia](https://en.wikipedia.org/wiki/XML_namespace)) The documentation around this is really poor.  Here's the [www3 definition](https://www.w3.org/TR/REC-xml-names/).

- [What does the `xmlns` in XML mean? (StackOverflow)](https://stackoverflow.com/questions/1181888/what-does-xmlns-in-xml-mean)
- [Where is xmlns attribute defined? (StackOverflow)](https://stackoverflow.com/questions/38634877/where-is-xmlns-attribute-defined)

So that means that the `xpath` function takes at least two arguments. The first argument is `//xmlnamespace:key`, the second is `target xmlnamespace => xmlns`.

Written more broadly:

```ruby
@doc.xpath('//fubar:tire', 'fubar' => 'http://alicesautoparts.com/')
#            xmlns:tire    
#                          bind_xmlns to this unique XMLNS ID
```

If you don't use the `xmlns` namespace, you get a namespace collision, but nokogiri doesn't tell you why. Just fails silently:

```ruby
@doc.xpath("//tire")
=> []
```

This works:

```ruby
@doc.xpath("//unique:tire", 'unique' => "http://bobsbikes.com/")
=> results
```

But beware a _tiny_ spelling error in the `xmlns` match value; if the string doesn't match exactly, `nokogiri` returns an empty array:

```ruby
@doc.xpath("//unique:tire", 'unique' => "http://bobsbikes.com") # missing trailing slash
=> []
```

# test_get_all_tires_belonging_to_bobsbikes_using_xpath

> get the tires for `bobs bikes`, and `alices' autoparts`. 

```ruby
@doc.xpath("//xmlns:tire", 'xmlns' => "http://bobsbikes.com/")
# bobs bikes

@doc.xpath("//carparts:tire", 'carparts' => 'http://alicesautoparts.com/')
# alices' autoparts
```

![these are the xlmlns things](/images/scraping_07.jpg)


# test_get_tires_from_aliceautoparts_using_css

Now, lets translate this to CSS:

> get the first set of tires (alices auto parts) using css

```ruby
@doc.css("xmlns|tire", "xmlns" => "http://alicesautoparts.com/")

# or we can use modern hash syntax:
@doc.css("xmlns|tire", xmlns: "http://alicesautoparts.com/")
```

# test_get_just_names_of_tires_in_an_array

>  Question: get _just the names of the tires_ in an array

Desired output:

```ruby
@doc.css("xmlns|tire", xmlns: "http://alicesautoparts.com/").map { |node| node.text }
=> ["all weather", "studded", "extra wide"]
```

# test_get_all_titles_using_xpath

Jump over to another pry session. this time we're using `atom.xml`:

```
$ pry
```

load up `nokogiri` and the file:

```ruby
>> require 'nokogiri'
=> true
>> @doc = Nokogiri::XML(File.read("atom.xml"))
# lots of output
```

> Grab all title tags


Here's the title tags we want in the xml:

![title tags](/images/scraping_08.jpg)

We would _think_ we could just grab all the xpath tags of `title`:

```ruby
>> @doc.xpath("//title")
=> []
```

Nope! I would have thought it would have given even a single entry. 

So, this works:

```ruby
@doc.xpath("//xmlns:title")
```

but so does this:

```ruby
@doc.xpath("//xmlns:title", 'xmlns' => 'http://www.w3.org/2005/Atom')
```

calling `xmlns` in the `xpath` function only seems to work if there's only a single `xmlns` value in the document. This syntax doesn't work in the `parts.xml` document:

```ruby
# in fresh pry session
require 'nokogiri'
@doc = Nokogiri::XML(File.read("parts.xml"))
@doc.xpath("//xmlns:tire")
=> # Nokogiri::XML::XPath::SyntaxError: ERROR: Undefined namespace prefix: //xmlns:tire
```


This is relevant, because the docs say:

> Don't be fooled though. You _do not_ have to use XPath to get the benefits of namespaces. CSS selectors can be used as well. CSS just uses the pipe symbol to indicate a namespace search

So, the basic principle at play with `xmlns` usage holds true with CSS namespacing. 

Rewrite the earlier command using CSS namspacing:

```ruby
# fresh pry session
>> require 'nokogiri'
=> true
>> @doc = Nokogiri::XML(File.open("atom.xml"))
@doc.css('xmlns|title')
=> [#(Element:0x3fcd5cc307f8 {
   name = "title",
   namespace = #(Namespace:0x3fcd5d070c64 { href = "http://www.w3.org/2005/Atom" }),
   children = [ #(Text "Example Feed")]
   }),
 #(Element:0x3fcd5d154158 {
   name = "title",
   namespace = #(Namespace:0x3fcd5d070c64 { href = "http://www.w3.org/2005/Atom" }),
   children = [ #(Text "Atom-Powered Robots Run Amok")]
   })]
```

And, good news:

> When using CSS, if the namespace is called "xmlns", you can even omit the namespace name. That means your CSS will reduce to:

```ruby
@doc.css('title')
```

the end of the `namespacing` conversation links to:

[http://tenderlovemaking.com/2009/04/23/namespaces-in-xml/](http://tenderlovemaking.com/2009/04/23/namespaces-in-xml/), which 404s. 

Turns out the page has been moved without a redirect to:

[https://tenderlovemaking.com/2009/04/23/namespaces-in-xml.html](https://tenderlovemaking.com/2009/04/23/namespaces-in-xml.html)



# test_full_name_last_employee

```ruby
# from new pry session
require 'nokogiri'
```

This is originally [discussed under the concept of "slop"](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#slop-1), because there's a `Nokogiri` mode called "slop", which the docs say over and over is a bad idea to use. So, instead of using the "sloppy" examples, we'll just work through the examples with regular non-sloppy `Nokogiri#css` selectors. 

### Question: Get the full name of the last employee

Desired output:

```
=> Jerry Lewis"
```

```ruby
@doc.css("employees").css("employee").last.css("fullname").text
=> "Jerry Lewis"
```

This is the first time I've chained `.css` onto itself: 

![double css what does it mean](/images/scraping_09.jpg)

# test_status_first_employee

> what is the first employee status?

```ruby
@doc.css('employee').first['status']
=> "active"
```
# test_name_of_inactive_employee

>  question: What is the name of the employee with an inactive status?

```ruby
@doc.css("[status='inactive']").css('fullname').text
```

I don't know why this selector requires the brackets around `status='inactive'`

OK. This concludes our exercises that arise from [Searching an XML/HTML document (Nokogiri docs)](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#namespaces)

# test_total_link_count

 OK! Jump in complexity time! 750 lines of HTML

The training wheels are coming off, but we're still working will well-bounded data. 

I just downloaded and saved to `docs_to_parse` the html for [https://josh.works/archive](https://josh.works/archive), as of April 2020. 

Open the HTML in your web browser of choice:

```
$ open docs_to_parse/josh_works_archive.html
```

You should see something like this:

![missing css, so it's ugly](/images/scraping_10.jpg)

I downloaded the html and saved it, via:

```
$ curl -L https://josh.works/archive -o josh_works_archive.html
```

Of course the "live" version of the page, which is able to load CSS, looks a bit better:

![live looks better](/images/scraping_11.jpg)

I wanted a "static" saved version for this next round of practice. We'll move to scraping "live" websites soon!

so, in a pry session:

```ruby
require 'nokogiri'
@doc = Nokogiri::HTML(File.open("docs_to_parse/josh_works_archive.html"))
```

> how many links are on the page?

I define `link` as `a href="..."`

```ruby
@doc.css("a")
# big ol result
@doc.css("a").count
=> 226
```
# test_list_all_hrefs_on_page

> how many posts are listed in the archive? 

![just the archives](/images/scraping_12.jpg)

Now, looking at the HTML, _someone_ stuffed all these links in an otherwise un-labled `<ul>` (er, that someone was me.)

Great. We'll have to figure out how to navigate this low-quality HTML. Good prep for the real world, right?

Here's the HTML we're working with, from the open `body` tag to the list of posts:

```html
<body>
  <div class="container content">
    <header class="masthead">
      <h3 class="masthead-title">
        <a href="/" title="Home">Josh Thompson</a>

        
          &nbsp;&nbsp;&nbsp;
          <small><a href="/about">about</a></small>
        
          &nbsp;&nbsp;&nbsp;
          <small><a href="/archive">archive</a></small>
        
          &nbsp;&nbsp;&nbsp;
          <small><a href="/turing">turing</a></small>
        
          &nbsp;&nbsp;&nbsp;
          <small><a href="/office-hours">office hours</a></small>
        
      </h3>
    </header>

    <main>
      <article class="page">
<h1 class="page-title">Archive</h1>

<ul>
<li>
  <p><a href="/2019-review"> 2019 Annual Review </a> <time class="archive-date">Jan 2020</time></p>
</li>
<li>
  <p><a href="/mythical-creature-refactor-ogre"> Refactoring practice: Getting rid of <code class="language-plaintext highlighter-rouge">attr_accessors</code> in <code class="language-plaintext highlighter-rouge">ogre.rb</code> </a> <time class="archive-date">Jan 2020</time></p>
</li>
<li>
  <p><a href="/mythical-creature-refactor-wizard"> Mythical Creatures: Refactoring wizard.rb </a> <time class="archive-date">Jan 2020</time></p>
</li>
```

Gosh, this is ugly HTML. 

First off, I notice that every archive link has a `time` tag associated with it, and the class `archive-date` associated with that tag. None of the other links on the page have this. 

```ruby
@doc.css("time").count
=> 221
```

OK, so that works. You can inspect a few of the time objects easily enough:

```ruby
@doc.css("time")[0..3].to_a
=> [#(Element:0x3fc4b88fcb10 {
   name = "time",
   attributes = [ #(Attr:0x3fc4b88f5b44 { name = "class", value = "archive-date" })],
   children = [ #(Text "Jan 2020")]
   }),
 #(Element:0x3fc4b8ae5e40 {
   name = "time",
   attributes = [ #(Attr:0x3fc4b8ae5558 { name = "class", value = "archive-date" })],
   children = [ #(Text "Jan 2020")]
   }),
 #(Element:0x3fc4b90c44ec {
   name = "time",
   attributes = [ #(Attr:0x3fc4b85a9b0c { name = "class", value = "archive-date" })],
   children = [ #(Text "Jan 2020")]
   }),
 #(Element:0x3fc4b8cf8160 {
   name = "time",
   attributes = [ #(Attr:0x3fc4b8cf5974 { name = "class", value = "archive-date" })],
   children = [ #(Text "Dec 2019")]
   })]
```

I wonder if we can grab the path each link links to, and get a list of just those paths, so the output would look like:

```
/2019-review
/mythical-creature-refactor-ogre
/mythical-creature-refactor-wizard
/why-i-sell-things-and-you-should-too
/shell-script-basics-change-mac-address
/poodr-ch-6-acquiring-behavior-through-inheritance
```

So, I think now we're getting into some interesting things.

Lets try gathering JUST this URL. I'm going to work on the last link here:

```ruby
@doc.css("a").last # returns the last link on the page, which happens to be a blog post URL
=> #(Element:0x3fc4b8a4993c {
  name = "a",
  attributes = [
    #(Attr:0x3fc4b8a498d8 { name = "href", value = "/three-ways-to-decide-what-to-be-when-you-grow-up" })],
  children = [ #(Text " Three Ways to Decide What to be When You Grow Up ")]
  })
```

Lets get the path value out of this. (`/three-ways-to-decide-what-to-be-when-you-grow-up`)

# test_list_all_hrefs_on_page

We can see that what we want is in the `attributes` value - `attributes = [{"href" => {}}]`.

```ruby
@doc.css("a").last.attributes
=> {"href"=>
  #(Attr:0x3fc4b8a498d8 { name = "href", value = "/three-ways-to-decide-what-to-be-when-you-grow-up" })}
```
and that's a `hash`, so we can access it with normal hash syntax:

```ruby
@doc.css('a').last.attributes["href"]
=> #(Attr:0x3fc4b8a498d8 
  { name = "href", value = "/three-ways-to-decide-what-to-be-when-you-grow-up" })
```

And we can go one level deeper and grab that value:

```ruby
@doc.css('a').last.attributes["href"]["value"] # Just kidding this totally doesn't work
=> nil
```

Lol. I typed out that sentence, so confident that I could go grab the thing I wanted, but... nope. No dice.

I got `nil`.

Which would be odd, if I was accessing a `Hash`, but I'm not:

```ruby
main:0> @doc.css("a").last.attributes["href"]
=> #(Attr:0x3fc4b8a498d8 { name = "href", value = "/three-ways-to-decide-what-to-be-when-you-grow-up" })
main:0> @doc.css("a").last.attributes["href"].class
=> Nokogiri::XML::Attr
```

By the time I'm looking at this smallest object, it's not a `hash` anymore, it's this `Nokogiri::XML::Attr`.

This begs the obvious question:
> What the heck is a `Nokogiri::XML::Attr`???

To the docs!

[Class: Nokogiri::XML::Attr (rubydoc.info)](https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Attr)

That helps a little. Most of the methods seem to be for updating/changing nodes, but this section of the page looks quite relevant:

![searchable nokogiri elements](/images/scraping_13.jpg).

We've been using the `#css` method quite a lot. I'd never actually looked at the documentation for this:

[`Nokogiri/XML/Searchable#css-instance_method`](https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Searchable#css-instance_method)

OK. The `css` method doesn't seem to help:

```ruby
@doc.css("a").last.attributes["href"].css("value")
=> []
@doc.css("a").last.attributes["href"].css("name")
=> []
```
but all of these options _did_ work:

```ruby
@doc.css("a").last.attributes["href"].text
=> "/three-ways-to-decide-what-to-be-when-you-grow-up"
@doc.css("a").last.attributes["href"].inner_html
=> "/three-ways-to-decide-what-to-be-when-you-grow-up"
> @doc.css("a").last.attributes["href"].children.text
=> "/three-ways-to-decide-what-to-be-when-you-grow-up"
```

I have no good mental model of this kind of thing that makes me nod and say "ah, that makes sense", but I expect more will become clear in time.

# test_get_path_for_first_link_that_has_sibling_element_of_time_class

### Question: Grabbing the last `time` html element, "jump" to the associated URL path.


```ruby
@doc.css('time').last
=> #(Element:0x3fc4b8c99408 {
  name = "time",
  attributes = [ #(Attr:0x3fc4b8c9937c { name = "class", value = "archive-date" })],
  children = [ #(Text "Dec 2012")]
  })
```

And by _only adding to the query_, how can I get the link next to it?

As a reminder, here's the html for this portion of the document:

```html
  <li>
    <p><a href="/three-ways-to-decide-what-to-be-when-you-grow-up"> Three Ways to Decide What to be When You Grow Up </a> <time class="archive-date">Dec 2012</time></p>
  </li>
</ul>
```

Phew. Took a lot of exploring, quite a phew calls of `thing.class` to see what I had, and then called `thing.methods` regularly to see if any of the methods that were listed looked promising. 

I found `#attribute` in the list of methods, it expected an argument, so I passed in `href` and that got me what I wanted:

```ruby
@doc.css('time').last.parent.css("a").attribute("href").value
=> "/three-ways-to-decide-what-to-be-when-you-grow-up"
```

This is the first time we've had to make much use of the `parent` method; it jumps "up" a level of the node tree, and then we use the `css` method to search the css of the node.

# test_list_all_paths_of_links_in_archive_portion_of_page

### Question: Generate a list of all `href` attributes on the page

Expected result:

![scraping](/images/scraping_14.jpg)

It should be 226 items long, and each item will be an instance of `Nokogiri::XML::Attr`

```ruby
@doc.css('a').map { |node| node.attribute("href") }
```

### Question: Generate an array of strings, representing every single `href` path on the page

Desired output:

![list of paths](/images/scraping_15.jpg)

As you might imagine, this is similar to the above question:

```ruby
@doc.css('a').map { |node| node.attribute("href").value }
=> => ["/",
 "/about",
 "/archive",
 "/turing",
 "/office-hours",
 "/2019-review",
 # etc
```

# test_array_of_strings_of_every_path_on_page

### Generate a list of paths, but restricting the results to the `archives`  section of the page

we're ready to re-address an earlier question. we can generate lists of things, and we can jump to "sibling" elements.

Remember how we "jumped" nodes when working on a single result?

Rebuild that in pry. Here's how I "rebuilt" it. remember - call `to_a` regularly to figure out what you're looking at.

```ruby
@doc.css('time').last
@doc.css('time').last.parent
@doc.css('time').last.parent.css('a')
@doc.css('time').last.parent.css('a').attribute("href")
@doc.css('time').last.parent.css('a').attribute("href").value
```

So, where do we "insert" an iterator to grab results from _every_ `time` element that matches our criteria, rather than just a single instance?

```ruby
@doc.css('time').last.parent.css('a').attribute("href").value
#                 ^^ this `last` looks like a good candidate

```

We're going to have to combine three things:
1. a result set (all 221 matching `Nokogiri::XML::Element` objects)
2. An iterator to map through each of the results
3. A `Nokogiri#css` select statement to gather the intended result, applied to each of the 221 matching results.

Lets see how these steps apply to the earlier "test" statement we built, to grab the value we wanted, but only from the last one on the page:

```ruby
@doc.css('time').last.parent.css('a').attribute("href").value
```

![breaking the statement down](/images/scraping_16.jpg)


So, we need to swap that yellow box from a single statement to something that lets us apply step 3 to all elements.

```ruby
@doc.css('time').map { |xml_element| xml_element.parent.css('a').attribute("href").value }
=> ["/2019-review",
 "/mythical-creature-refactor-ogre",
 "/mythical-creature-refactor-wizard",
 "/why-i-sell-things-and-you-should-too",
 "/shell-script-basics-change-mac-address",
 # etc
```

Nailed it! Here's the change that we made:

![the update](/images/scraping_17.jpg)

And this gives us 221 results. 



### scraping "ask HN" thread to get list of personal blogs to visit

now I'm ready for the thing I wanted to do, that sent me on this whole rabbit trail in the first place.

I recently read [Ask HN: What is your blog and why should I read it?](https://news.ycombinator.com/item?id=22800136).

I thought it would be cool to build a little rails app that scrapes this thread for blog posts, and every time you visit it, it give you a few of those posts. Sort of a very "bespoke" curated content finding and discovery service. 

I know how to do most of this... from the database on up. How to _get_ the data in the database, I was less sure of. 

I figured I'd write a ruby script that would grab this post's html, use nokogiri to find all the URLs, do some validation/deduplication, and stuff them in a database. 

Then I'd render some sampling of that DB content to the front end. 

> using `hn_blog_posts.html`

That was then I googled around for basic Nokogiri practice, and couldn't find anything that got me up and running quickly enough to make intelligent guesses on building this out. 

And here we are...

Anyway, lets try to find this link!

![finding_links](/images/scraping_19.jpg)

Hop into a pry session, and we'll download the webpage and figure this out
```
$ pry
> require 'nokogiri'
> require 'open-uri'
> doc = Nokogiri::HTML(open("https://news.ycombinator.com/item?id=22800136"))
```

Poking around the HTML of the hacker news page, it looks like all the comments are in a `span` with the exact same class name:

![span and same class](/images/scraping_20.jpg)

```ruby

# difference between: 
doc.children
doc.children.count
doc.children.class
doc.children.first.to_a
doc.children.first
doc.css('span')
doc.css('.comment-tree')
doc.css('.comment-tree')
doc.css('.comment-tree')
doc.css('.comment-tree').css('tr')
doc.css('.comment-tree').css('tr').first
doc.css('.comment-tree').css('tr').first.class
```


Took a bunch of false starts to figure out exactly what to call. 


unwanted comment xpath (right-click 'copy as xpath')

`/html/body/center/table/tbody/tr[3]/td/table[2]/tbody/tr[2]/td/table/tbody/tr/td[3]/div[2]/span`

:scream: this isn't helpful. 

```ruby
comment.css('a').map { |n| n.text }
=> ["https://paulstamatiou.com/",
 "https://paulstamatiou.com/getting-started-with-security-keys...",
 "https://paulstamatiou.com/building-a-windows-10-lightroom-ph...",
 "https://paulstamatiou.com/stuff-i-use/"]
```

not what we want.

Getting closer, but still not quite. I ended up getting the truncated URLs

![truncated urls](/images/scraping_21.jpg)


```ruby
doc.css('.commtext')
doc.css('.commtext').first

commment = _ # setting comment equal to a single commtext instance, so I can save typing

comment.css('a').attribute("href").value
doc.css('.commtext').first.css('a').attribute("href").value

doc.css('.commtext').map do  |comment| 
  comment.css('a').map do |a|
    a.attribute('href').value
  end
end
# HOLY COW IT DID SOMETHING!
```

![it's alive!!!](/images/scraping_22.jpg)

Scratches head.... now what? Do I want threads only in top-level comments? 

Lets just start there. Seems like a reasonable design criteria. 

First, I found a unique string that I knew couldn't be in a top-level comment. I needed to make this grab only top-level comments.

Maybe all children comments have a different parent than top-level comments?

if top-level comments have a parent of a `tr` or something, and all other comments have a parent of a `span`, we might be in business. 

```ruby
doc.css('.commtext') # array of comments
doc.css('.commtext').first.parent.name
=> "div" # top level comment has a div for a parent
doc.css('.commtext').first.name
=> "span" # cop level comment IS a span
doc.css('.commtext').first.child.name
=> "a"
doc.css('.commtext').first.children.map {|n| n.parent.name }
# looking through all children, making sure none have a div for parent.name
=> ["span", "span", "span", "span", "span"]
```

off to the docs. I think I can understand them now!

Here's a big list of all selectors you may be able to use: [https://www.w3.org/TR/selectors-3/#selectors](https://www.w3.org/TR/selectors-3/#selectors)

And scoping the above list down to [attribute selectors](https://www.w3.org/TR/selectors-3/#attribute-selectors)

I have no idea how to read these docs right now. Pretty much everything on this docs page means nothing to me:

![huh?](/images/scraping_23.jpg)

Lets make examples out of all this:

Lets look at each row, and break each section down into something intelligble to me:


| Pattern |	Represents |	Description |	Level |
|---------|------------|--------------|-------|
| `*` |	any element	| Universal selector |	2 |

`pattern: *`

This `pattern` value is the selector that can be passed into a Nokogiri selector. For example:

```ruby
doc.css('*')

```

`Represents: any element`

Sounds like this can represent any element? 

`Description: Universal Selector`

Describes everything? the universe? [ww3.org "universal selectors" docs](https://www.w3.org/TR/selectors-3/#universal-selector)

`Level: 2`

No clue. Googled `css selector levels` and got [Selectors from level 4 to 1](https://css4-selectors.com/selectors/).

I think this is a "precedence" thing - level 1 selectors will out-compete level 2 selectors, or something like that.

If you worked together both a level 1 and level 2 selector, I could see level 2 perhaps not showing up because level 1 "beats" it, or something. I'll figure this out as we go. 


| Pattern |	Represents |	Description |	Level |
|---------|------------|--------------|-------|
| `E` |	any element of type `E`	| Type selector |	1 |

The `pattern` value can represent any HTML element:

```ruby
doc.css('div')
doc.css('p')
doc.css('a')
doc.css('table')
```

`Description: Type selector`

[link to type selector in docs](https://www.w3.org/TR/selectors-3/#type-selectors).


Third row:

| Pattern |	Represents |	Description |	Level |
|---------|------------|--------------|-------|
| `E[foo]` |	an E element with a "foo" attribute	| Attribute selector |	2 |

We're starting to get into some good stuff, I think. 

So, we know what `E element` means - `div`, `span`, `a`, etc.

What does `attribute` mean? 

> an `E` element with `foo` attribute: `E[foo]`

Lets make an example. Googled around, this is from [HTML Attribute (Wikipedia)](https://en.wikipedia.org/wiki/HTML_attribute)

> HTML attributes generally appear as name-value pairs, separated by =, and are written within the start tag of an element, after the element's name: 

```html
<element attribute="value">element content</element>
```

Lets find some real world examples, and try to build a mental model from it:

Opening up the network tab for that wikipedia page, and inspecting the HTML from this very example:

![example attributes](/images/scraping_24.jpg)

Another example, from the HN page we're working to process:

![grabbing html attributes](/images/scraping_25.jpg)

We can see some interesting progressions here:

```ruby
# using the nokogiri-parsed version of the hacker news thread
doc.css('a').count
=> 1600
doc.css('a[href]').count
=> 1600
doc.css('a[href="https://paulstamatiou.com/"]').count
=> 1
```

Lets get some more practice.

Jumping over to [Learn Enough Command Line to Be Dangerous](https://www.learnenough.com/command-line-tutorial/basics), lets try to grab the links in the first "aside" box, per this screenshot:

![grab just these links](/images/scraping_26.jpg)

```ruby
# open a new pry session: $ pry
require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open('https://www.learnenough.com/command-line-tutorial/basics'))
doc.css('div') # we know this will grab all the divs on the page. not helpful.
doc.css('div').count 
=> 133
doc.css('div[id]') # this will grab all the divs WITH AN ID ATTRIBUTE!
doc.css('div[id]').count
=> 21
doc.css('div[id="aside-computer_magic"]') # this should grab the div from the above screenshot!
=> [] # but it totally doesn't work. :(
```

wow. Really struggling to get this to work. I can do this on my website:

```ruby
@jw = Nokogiri::HTML(open("https://josh.works/"))
@jw.css('h2[id="programming"]')
=> [(Element:0x3fe16f513e80 {
   name = "h2",
   attributes = [ (Attr:0x3fe16f513534 { name = "id", value = "programming" })],
   children = [ (Text "Programming")]
   })]
```
OK, this works:

```ruby
@hartl = Nokogiri::HTML(open("https://www.learnenough.com/command-line-tutorial/basics"))
@hartl.css('strong[class="book-author-name"]')
```
Ah. The reason the nokogiri selector wasn't working to try to grab the links we wanted was because that bit of HTML wasn't included when we tried to open the URL:

```shell
$ curl -L https://www.learnenough.com/command-line-tutorial/basics -o hartl.html
$ open hartl.html
```

Take a look at that HTML doc; doesn't include the elements we wanted to play with. 

Phew. What a relief! 

Lets try a different page, maybe one where the entire expected HTML doc comes back in a single request.

I've recently been reading [https://commoncog.com/blog/](https://commoncog.com/blog/), and have found it to be _exceptional_. 10x better than pretty much anything I've found on the internet. And it came from the `ask hn: what's your personal blog and why should I read it` thread. 

We're going to try to get these links:

![lets get this](/images/scraping_27.jpg)

```ruby
# new pry session
require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open("https://commoncog.com/blog/"))
```

Now, look at this screenshot again. Can we figure out something true about these links we want?

```ruby
doc.css('li[class="sidebar__nav__li"]')
# boom! works!
```

This returns a `Nokogiri::XML::NodeSet` containing the nodes we want; we have to filter out the info we want.  

Here's the first pass at building up the query. Note that I use `.first` to translate from methods called on the collection to methods called on the instance. I'll translate this to `.map` in the next step:

```ruby
doc.css('.sidebar__nav__li').first.css('a').attribute('href').value
=> "http://commoncog.com/blog/about/"

# got what I wanted from a single instance of that NodeSet. Now to iterate through all of them:

doc.css('.sidebar__nav__li').map { |n| n.css('a').attribute('href').value }
=> ["http://commoncog.com/blog/about/",
 "http://commoncog.com/blog/career-moats-101/",
 "http://commoncog.com/blog/subscribe-to-the-commonplace-newsletter/",
 "http://commoncog.com/blog/a-framework-for-putting-mental-models-to-practice/",
 "http://commoncog.com/blog/the-principles-sequence/",
 "http://commoncog.com/blog/the-forecasting-series/",
 "http://commoncog.com/blog/the-chinese-businessman-paradox/",
 "http://commoncog.com/blog/the-ultimate-guide-to-reading-a-book-a-week-for-your-career/",
 "https://commoncog.com/",
 "http://commoncog.com/blog/about/",
 "http://commoncog.com/blog/career-moats-101/",
 "http://commoncog.com/blog/subscribe-to-the-commonplace-newsletter/",
 "http://commoncog.com/blog/a-framework-for-putting-mental-models-to-practice/",
 "http://commoncog.com/blog/the-principles-sequence/",
 "http://commoncog.com/blog/the-forecasting-series/",
 "http://commoncog.com/blog/the-chinese-businessman-paradox/",
 "http://commoncog.com/blog/the-ultimate-guide-to-reading-a-book-a-week-for-your-career/",
 "https://commoncog.com/"]
```
And, how might be go about grabbing all the links on the page? quick check-for-understanding?

```ruby
doc.css('a').map { |n| n.attribute('href').value }
=> ["http://commoncog.com/blog",
 "#subscribe",
 "/blog/watch-the-cash-flow/",
 "/blog/watch-the-cash-flow/",
 "/blog/career-moats-in-recession/",
 # etc
```

So, I'd say we've now experimented a bit with these selectors:

| Pattern |	Represents |	Description |	Level |
|---------|------------|--------------|-------|
| `E[foo]` |	an E element with a "foo" attribute	| Attribute selector |	2 |
| `E[foo="bar"]` |an `E` element whose "foo" attribute value is exactly equal to "bar" | Attribute Selector | 2 |


Lets try:

| Pattern |	Represents |	Description |	Level |
|---------|------------|--------------|-------|
| `E[foo~="bar"]` |	an E element whose "foo" attribute value is a list of whitespace-separated values, one of which is exactly equal to "bar" | Attribute Selector | 2 |

Lets find some examples where something like this could be useful. 

Back to the hacker news page:

Lets get this:

![c00](/images/scraping_28.jpg)

As a reminder, we can easily grab all the elements with a class of `commtext` without difficulty:

```ruby
doc.css('.commtext').count
=> 250
```

But what if we call for `c00`?

```ruby
hn.css('.c00').count
=> 250
```

Now, lets use the element selector piece:

```ruby
doc.css('span[class="commtext"]').count
=> 0 # huh? we know there's 250 spans with this class\
doc.css('span[class~=commtext]').count
=> 250 # nailed it. The class didn't `exactly equal` commtext, the class had a list of 
# whitespace-separated values, one of which is exactly equal to commtext. 
# we should expect this to work with the other class given to this span:
doc.css('span[class~=c00]').count
```

# Structural pseudo-classes

OK, I'm going to skip down the list of selectors a bit. Here's how much of the [selectors summary](https://www.w3.org/TR/selectors-3/#selectors) we've worked through:

![summary](/scraping_29.jpg)

All of the selectors that reference [Structural pseudo-classes](https://www.w3.org/TR/selectors-3/#structural-pseudos) seem interesting, so lets figure them out!

The first question that I had was:

> What the heck is a structural pseudo-class?

The definition is:

> Selectors introduces the concept of *structural pseudo-classes* to permit selection based on extra information that lies in the document tree but cannot be represented by other simple selectors or combinators.

This still doesn't help. I googled `structural pseudo-classes examples`

Ended up on [Getting to Know CSS3 Selectors: Structural Pseudo-Classes (Sitepoint)](https://www.sitepoint.com/getting-to-know-css3-selectors-structural-pseudo-classes/)

OK, syntax for using the `root` pseudo-class:

```ruby
doc.css(':root')
=> # returns a giant object that looks suspiciously similar to `doc`
```
I'm not seeing much utility here. Other examples that gave results:

```ruby
doc.css('html:root') # returned something
doc.css('table:root') # returned nothing
doc.css('span:root') # returned nothing
doc.css('div:root') # returned nothing
doc.css('p:root') # returned nothing
doc.css('body:root') # returned nothing
```

oh well.

On to the next row:

| Pattern |	Represents |	Description |	Level |
|---------|------------|--------------|-------|
| `E:nth-child(n)` |	an E element, the n-th child of its parent | Structural pseudo-classes | 3 |

OK. Now lets look at `:only-child`

```ruby
doc.css(':only-child').count
=> 3523
```

Presumably this is the count of all elements that are the only child of their parent element. They likely have no sibling nodes.

------------------------------

Feels like a waste of time. Back to the hacker news jobs thread

```ruby
doc.css('table[class="comment-tree"]').css('tr')
doc.css('table[class="comment-tree"]').first.css('.comment').first
doc.css('table[class="comment-tree"]').map { |n| n.css('.comment').first }
doc.css('table[class="comment-tree"]').first.css('.comment').first.css('a').to_a.first.text
doc.css('table[class="comment-tree"]').map {|n| n.css('.comment').map {|c| c.css('a').map {|a| a.text } } }
```

This last one seems pretty close to what I want. 

```ruby
doc.css('table[class="comment-tree"] > tr').first.css('p')
doc.css('table[class="comment-tree"] > tr').first.css('p').css('a').first.attribute('href').value
doc.css('table[class="comment-tree"] > tr').first.css('p').css('a').map {|a| a.attribute('href').value }
doc.css('table[class="comment-tree"] > tr').map { |c| c.css('p').css('a').map {|a| a.attribute('href').value } }
# very close. Gets many unwanted "reply" links, though. 
```






### By the end of this set of exercises, you will be able to comfortably use Nokogiri to do the following:

referencing `shows.xml`:
- list of all the characters in all the shows in this document
- Get the characters who performed in Dramas
- Get the first drama name back in _four_ different ways
- get the names of sitcoms

referencing `parts.xml`

- Get all the tires belonging to 'http://aliceautoparts.com/' using `xpath`
- Get all the tires belonging to an `xmlns` value of `http://bobsbikes.com/` using `xpath`
- get the first set of tires (alices auto parts) using `css`
- get _just the names of the tires_ in an array

referencing `atom.xml`

- get all titles using `xpath`
- get all titles using `css`


referencing `employees.xml`

- get the full name of the last employee
- what is the first employee status?
- What is the name of the employee with an inactive status?

referencing `josh_works_archive.html`

- how many links are on the page?
- using the `a` css selector, what is the `path` of the last link in the document?
- Generate a list of all `href` attributes on the page
- Generate an array of strings, representing every single `href` path on the page
- Generate array of relative_paths, representing all `href`s in the ARCHIVE portion of the page. Don't include non-archive URLs. (should be 221 results long)

referencing `hn_blog_posts.html`:

- 

#### TODOs for josh

- notify [@tenderlove](https://twitter.com/tenderlove) of broken redirect from [https://nokogiri.org/tutorials/searching_a_xml_html_document.html#namespaces](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#namespaces) to [https://tenderlovemaking.com/2009/04/23/namespaces-in-xml.html](https://tenderlovemaking.com/2009/04/23/namespaces-in-xml.html)

#### Misc Resources

- [CSS Selector Reference (W3 schools)](https://www.w3schools.com/cssref/css_selectors.asp)
- [Child and Sibling Selectors (CSS Tricks)](https://css-tricks.com/child-and-sibling-selectors/)
- [THE BEGINNER’S GUIDE: Scraping in Ruby Cheat Sheet (Medium.com/@LindaVivah)](https://medium.com/@LindaVivah/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c)
- [CSS Selectors from level 4 to 1](https://css4-selectors.com/selectors/)
- [Intriguing CSS Level 4 Selectors](https://webdesign.tutsplus.com/tutorials/intriguing-css-level-4-selectors--cms-29499)
