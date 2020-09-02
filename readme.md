# Intermediate Ruby Obstacle Courses

This repo contains a collection of "obstacle courses" that are laser-focused on _quickly_ leveling up very discrete skills.

I'm building these resources to help myself learn (slowly) and then to be able to hand this resource to someone else, and in a _fraction_ of the time it took me to learn this, I want them to be able to learn >60% of what I've learned.

_note: You probably got here by way of [intermediateruby.com](https://intermediateruby.com/intermediate-ruby-obstacle-course). Head over there for more context and information:_

_[https://intermediateruby.com/intermediate-ruby-obstacle-course](https://intermediateruby.com/intermediate-ruby-obstacle-course)_

### Current "obstacle courses"

- Nokogiri Obstacle Course
- Rubocop Obstacle Course

------------------------------------

## Nokogiri Obstacle Course

> Become a better developer

isn't super actionable.

On the flip side

> Write good tests for your views

_is_ actionable, and has the side effect of helping you get better at writing integration tests that use css-selector-based assertions.

Integration tests differ from unit tests, in that they should show all the individual bits of functionality of your app "integrated" together. They're often written in a format of:

```
when I visit logged_in_admin_dashboard_path
I expect to see {account.name} in {some location}
I expect to see {statistics} in {other page location}
I expect to see {comments} in {another location}
```

The "location" pieces are usually defined with CSS selectors, which uses a mix of [Selenium](https://www.selenium.dev/), [Capybara](https://github.com/teamcapybara/capybara) and [Nokogiri](https://github.com/sparklemotion/nokogiri).

These tests use `minitest`, but this knowledge will be perfectly portable to `rspec` testing as well. 

So, this `nokogiri obstacle course` will help you write better integration tests!

To write integration tests, you need to understand the basics of parsing the DOM. To do this, you need to use a tool called `nokogiri`.

Beyond testing views, you can also use nokogiri to scrape websites.

Before I started this Nokogiri project, I said to myself:

> Hey, I kinda know how to use Nokogiri...

And could kinda-sorta stumble my way through some web scraping, but I couldn't do anything complicated with it, and didn't feel confident that I could sit down and scrape arbitrary data from an arbitrary webpage.

To get started, clone down this repo using the following URL:

```shell
$ git clone git@github.com:josh-works/intermediate_ruby_obstacle_course.git
# if you need to use https: git clone https://github.com/josh-works/intermediate_ruby_obstacle_course.git
$ cd intermediate_ruby_obstacle_courses
$ bundle install
$ atom . # or whatever command you use to open up a repo in your code editor
```
There's a `readme.md` file with detailed information on each of the 21 tests you'll work through, located in the `nokogiri` directory. Once you clone this repo down, open up the `readme`, and get to work!

You can also navigate to https://github.com/josh-works/intermediate_ruby_obstacle_course/tree/master/nokogiri in your browser, to see what's in the README. 

--------------------------

# Contributors

These are generous, kind, competent, empathetic developers that have contributed to this project, and if they're ever available to hire, _hire them immediately_ because they won't be on the market for long

- [Alice Post](https://github.com/ap2322)
- [Daniel Frampton](https://github.com/DanielEFrampton)
- [Mark Modak](https://github.com/markevan100/)
