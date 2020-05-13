# Rubocop Obstacle Course

It's very common to have to add/work with Rubocop on Rails apps.

Lets quickly get _your_ knowledge up and running, so with an hour or two of work, you'll be the local Rubocop expert!

Steps so far:

1. Add Rubocop to Gemfile 
2. Add/configure `.rubocop.yml` to project root
3. Set useful starting points, cops, warning levels, etc.

Lets checkout this repo at this commit: `9d9e910`, basically, right before I started adding anything to this file. 

### Useful Rubocop-related commands

```shell
$ rubocop
# runs rubocop against entire repository to check for offenses

$ rubocop -a 
# run rubocop in "autocorrect" mode. I DON'T WANT TO EVER USE THIS!

$ rubocop --auto-gen-config
# generates a .rubocop_todo.yml, modifies .rubycop.yml to inherit from new file
# by placing `inherit_from: .rubocop_todo.yml` at top of file. 
```

So, we auto-generated a TODO, now `rubycop` doesn't throw errors as we've basically hidden current problems.

Lets first see some actual cops.

Take a look at all the cops that `--auto-gen-config` decided to bring in:

```yml
# .rubocop_todo.yml
# first entry

# Offense count: 4
# Cop supports --auto-correct.
Layout/CommentIndentation:
  Exclude:
    - 'nokogiri/nokogiri_test.rb'
```

So, head over to [all rubycop cops](https://github.com/rubocop-hq/rubocop/tree/master/lib/rubocop/cop), and click into the `layout` directory. There we'll find the [`Layout/CommentIndentation` cop](https://github.com/rubocop-hq/rubocop/blob/master/lib/rubocop/cop/layout/comment_indentation.rb).

So, what exactly is the problem? Let's understand this exact cop, the errors, etc. Lets run this specific cop against this specific file:


```
rubycop --only "Layout/CommentIndentation"
```

It doesn't throw any errors, though, because we've excluded this cop in the `.rubocop_todo.yml`; comment out the exclusion, re-run the file, and we get results:

```

nokogiri/nokogiri_test.rb:42:5: C: Layout/CommentIndentation: Incorrect indentation detected (column 4 instead of 6).
    # Desired output:
    ^^^^^^^^^^^^^^^^^
nokogiri/nokogiri_test.rb:46:7: C: Layout/CommentIndentation: Incorrect indentation detected (column 6 instead of 4).
      #(Element:0x3fbfb64f44d4 { name = "character", children = [ #(Text "\"Howling Mad\" Murdock")] })]
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
nokogiri/nokogiri_test.rb:238:5: C: Layout/CommentIndentation: Incorrect indentation detected (column 4 instead of 6).
    # [#(Attr:0x3fc00bcf596c { name = "href", value = "/" }),
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
nokogiri/nokogiri_test.rb:242:7: C: Layout/CommentIndentation: Incorrect indentation detected (column 6 instead of 4).
      #(Attr:0x3fc00bcf587c { name = "href", value = "/office-hours" }), etc
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

2 files inspected, 4 offenses detected
```

Lets see about fixing these. _Manually_, because I want to learn to understand things, not just let linters go crazy.

So, this `Layount/CommentIndentation` cop is good! It caught a few problems, and now we're good to go. 

So, I can remove that line from `.rubycop_todo.yml`, and now running `rubycop` _still_ returns now errors, but we've made modest improvements to the codebase. 

Lets do one more cop, [Layout/EmptyLineBetweenDefs](https://github.com/rubocop-hq/rubocop/blob/master/lib/rubocop/cop/layout/empty_line_between_defs.rb)

Comment out the `todo` entry, run rubocop, manually fix the suggestsions, and all is green!

-------------------------------------------

Now, lets see if we can set up a hook to run Rubocop every time we run our tests.

I'd like `rake test` or `rails test` to run Rubocop. 


### Resources

- [Rubocop Docs: Basic Usage](https://docs.rubocop.org/en/stable/basic_usage/)
- [all Rubocop cops](https://github.com/rubocop-hq/rubocop/tree/master/lib/rubocop/cop)
- [Running Rubocop Only On Modified Files](https://medium.com/devnetwork/running-rubocop-only-on-modified-files-a21aed86e06d)