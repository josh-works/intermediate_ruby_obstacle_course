
_This repo exists because I worked through [THE BEGINNER’S GUIDE: Scraping in Ruby Cheat Sheet](https://medium.com/@LindaVivah/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c), and step 10 made a HUGE leap with nokogiri knowledge, and I felt skipped a huge piece I didn't understand. I made the exercise work, but I still didn't know enough about nokogiri to go solve novel problems with it._

_This collection of exercises will *quickly* get you comfortable enough in nokogiri to do fascinating things quickly using it_



To work through same exercises the Nokogiri docs give on [Searching a XML/HTML document](https://nokogiri.org/tutorials/searching_a_xml_html_document.html)

Clone down this repo. 

```
$ git clone <link to this repo>
$ cd intermediate_ruby_obstacle_course
```

At same relative path as this `readme`, do

```
$ gem install nokogiri
```

start a pry session

```
$ pry 
```

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

OK, if you've gotten this far, you're ready to really benefit from, and practice, the examples in [Basic Searching](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#basic-searching)

If you work through this document, and do the exercises, by the end you'll be able to complete the following challenges:

### Check for understanding

- easy: get a list of all the characters in all the shows in this document
- hard: use css selectors to count the number of links in `josh_works_archive.html`

- easy: You can use any XPath or CSS query you like (see the chapter on XPath and CSS syntax for more information).
- hard: 

- how to nicely print a NodeSet to your terminal so you can figure out the results you're looking at!

# Use any XPath or CSS query you like (see the chapter on XPath and CSS syntax for more information) to get list of characters

Desired outcome:

```
# => ["<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

```

[#<Nokogiri::XML::Element:0x3fe36f0c7c30 name="character" children=[#<Nokogiri::XML::Text:0x3fe36e97a6d0 "John \"Hannibal\" Smith">]>, #<Nokogiri::XML::Element:0x3fe36f0a6d50 name="character" children=[#<Nokogiri::XML::Text:0x3fe36f08e1b0 "Templeton \"Face\" Peck">]>, #<Nokogiri::XML::Element:0x3fe36e96f08c name="character" children=[#<Nokogiri::XML::Text:0x3fe36f07afd4 "\"B.A.\" Baracus">]>, #<Nokogiri::XML::Element:0x3fe36e457a90 name="character" children=[#<Nokogiri::XML::Text:0x3fe36e452428 "\"Howling Mad\" Murdock">]>]

```

This is how it looked in Pry:

![rather difficult to read](/images/scraping_01.jpg)

Here's the above line, spaced out a bit better:

```
[#<Nokogiri::XML::Element:0x3fe36f0c7c30 name="character" children=[#<Nokogiri::XML::Text:0x3fe36e97a6d0 "John \"Hannibal\" Smith">]>, 
 #<Nokogiri::XML::Element:0x3fe36f0a6d50 name="character" children=[#<Nokogiri::XML::Text:0x3fe36f08e1b0 "Templeton \"Face\" Peck">]>, 
 #<Nokogiri::XML::Element:0x3fe36e96f08c name="character" children=[#<Nokogiri::XML::Text:0x3fe36f07afd4 "\"B.A.\" Baracus">]>, 
 #<Nokogiri::XML::Element:0x3fe36e457a90 name="character" children=[#<Nokogiri::XML::Text:0x3fe36e452428 "\"Howling Mad\" Murdock">]>
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

Looked through tons of Pry git issues...

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

> Get the first drama name back in two different ways

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


### Question: get the names of all sitcoms

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


# Now the tutorial jumps to using `parts.xml`

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

### Challenge: Get all the tires belonging to 'http://aliceautoparts.com/'

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

get the tires for `bobs bikes`, and `alices' autoparts`. 

```ruby
@doc.xpath("//xmlns:tire", 'xmlns' => "http://bobsbikes.com/")
# bobs bikes

@doc.xpath("//carparts:tire", 'carparts' => 'http://alicesautoparts.com/')
# alices' autoparts
```

![these are the xlmlns things](/images/scraping_07.jpg)

Now, lets translate this to CSS:

### Question: get the first set of tires (alices auto parts) using css

```ruby
@doc.css("xmlns|tire", "xmlns" => "http://alicesautoparts.com/")

# or we can use modern hash syntax:
@doc.css("xmlns|tire", xmlns: "http://alicesautoparts.com/")
```

### Question: get _just the names of the tires_ in an array

Desired output:

```ruby
@doc.css("xmlns|tire", xmlns: "http://alicesautoparts.com/").map { |node| node.text }
=> ["all weather", "studded", "extra wide"]
```

# atom.xml examples

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

### Question: Grab all title tags


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


# Employees.xml examples

```ruby
# from new pry session
require 'nokogiri'
```

This is originally discussed under the concept of "slop", because there's a `Nokogiri` mode called "slop", which the docs say over and over is a bad idea to use. So, instead of using the "sloppy" examples, we'll just work through the examples with regular non-sloppy `Nokogiri#css` selectors. 

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



### Question: what is the first employee status?

```ruby
@doc.css('employee').first['status']
=> "active"
```

###  Question: What is the name of the employee with an inactive status?

```ruby
@doc.css("[status='inactive']").css('fullname').text
```

I don't know why this selector requires the brackets around `status='inactive'`

OK. This concludes our exercises that arise from [Searching an XML/HTML document (Nokogiri docs)](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#namespaces)


# OK! Jump in complexity time! 750 lines of HTML

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

### Question: How many links are on the page?

I define `link` as `a href="..."`

```ruby
@doc.css("a")
# big ol result
@doc.css("a").count
=> 226
```

### Question: how many posts are listed in the archive? 

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

I have no good mental model of this kind of thing that makes me nod and say "ah, that makes sense". 



# Condensed set of questions you should be able to answer FROM THE BEGINNING in less than 4 minutes:


### shows.xml

- list of all the characters in all the shows in this document
- Get the characters who performed in Dramas
- Get the first drama name back in _four_ different ways
- get the names of sitcoms

### parts.xml

- Get all the tires belonging to 'http://aliceautoparts.com/' using `xpath`
- Get all the tires belonging to an `xmlns` value of `http://bobsbikes.com/` using `xpath`
- get the first set of tires (alices auto parts) using `css`
- get _just the names of the tires_ in an array

### atom.xml

- get all titles using `xpath`
- get all titles using `css`


### employees.xml

- get the full name of the last employee
- what is the first employee status?
- What is the name of the employee with an inactive status?

### josh_works_archive.html

- how many links are on the page?


## TODO 

- notify [@tenderlove](https://twitter.com/tenderlove) of broken redirect from [https://nokogiri.org/tutorials/searching_a_xml_html_document.html#namespaces](https://nokogiri.org/tutorials/searching_a_xml_html_document.html#namespaces) to [https://tenderlovemaking.com/2009/04/23/namespaces-in-xml.html](https://tenderlovemaking.com/2009/04/23/namespaces-in-xml.html)

## Resources

- [CSS Selector Reference (W3 schools)](https://www.w3schools.com/cssref/css_selectors.asp)
- [Child and Sibling Selectors (CSS Tricks)](https://css-tricks.com/child-and-sibling-selectors/)