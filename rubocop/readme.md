# Rubocop Obstacle Course

It's very common to have to add/work with Rubocop on Rails apps.

Lets quickly get _your_ knowledge up and running, so with an hour or two of work, you'll be the local Rubocop expert!

Steps so far:

1. Add Rubocop to Gemfile 
2. Add/configure `.rubocop.yml` to project root
3. Set useful starting points, cops, warning levels, etc.

Lets checkout this repo at this commit: `9d9e910`, basically, right before I started adding anything to this file and making the recommended fixes. 

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

So, lets create what we need, and by that I mean "find something on Stack Overflow that gives us what we want": 

```ruby
# lib/tasks/test.rake
require 'rubocop/rake_task'

# Add additional test suite definitions to the default test task here
namespace :test do
  desc 'Runs RuboCop on specified directories'
  RuboCop::RakeTask.new(:rubocop) do |task|
    # Dirs: app, lib, test
    task.patterns = ['app/**/*.rb', 'lib/**/*.rb', 'test/**/*.rb']

    # Make it easier to disable cops.
    task.options << "--display-cop-names"

    # Abort on failures (fix your code first)
    task.fail_on_error = false
  end
end

Rake::Task[:test].enhance ['test:rubocop']
```

Other goodies to know with Rubocop:

### Show violations, grouped by count

```
rubycop --format offenses
```

[Formatters `offense count` documentation](https://docs.rubocop.org/en/latest/formatters/#offense-count-formatter)

![show offense count](/images/rubocop-formatters-summary.jpg)


This does what I want:

![i am dumb](/images/rubocop-tried-to-execute-shell-command-wrong-place.jpg)

### Run Rubocop only on modified files, using `git ls-files`

So, after some futzing around, I figured out how to run Rubocop only on modified files. I don't really love this, but https://stackoverflow.com/questions/15008751/how-to-integrate-rubocop-with-rake gave me the info I needed.

Take a look at what I pass through to `exec` in each of the following tasks:

```ruby

namespace :rubocop do
  desc 'Run RuboCop on modified files'
  task :modified do
    # running shell comands directly is ugly, but currently good enough?
    # https://stackoverflow.com/questions/15008751/how-to-integrate-rubocop-with-rake
    exec 'git ls-files -m | xargs ls -1 2>/dev/null | grep "\.rb$" | xargs rubocop --format simple'
  end

  desc 'Run RuboCop on staged files'
  task :staged do
    puts "Run RuboCop on staged files"
    exec('git diff --staged --name-only | xargs ls -1 2>/dev/null | grep "\.rb$" | xargs rubocop --format simple')
  end

  desc 'Auto-fix RuboCop lint errors in staged files'
  task :fix do
    exec('git diff --staged --name-only | xargs ls -1 2>/dev/null | grep "\.rb$" | xargs rubocop --auto-correct')
  end
end

```

## Rubocop and CircleCI

This is what we ended up with:

```
# .circlieci/config.yml

# Use Rubocop for linting (limited to only warning-level offenses)
# See https://github.com/rubocop-hq/rubocop/blob/master/manual/configuration.md#severity
- run:
    name: run linter
    command: |
      bundle exec rubocop --fail-level W --display-only-fail-level-offenses
```

And I ran that line in the terminal repeatedly to find warn-level offenses

```
bundle exec rubocop --fail-level W --display-only-fail-level-offenses
```

and this, to clean up the output:

```
bundle exec rubocop --fail-level W --display-only-fail-level-offenses --format offenses
bundle exec rubocop --fail-level W --display-only-fail-level-offenses --format simple
```

(note the `--format simple`, `--format offenses` args)


# Cheat sheet for quickly adding Rubocop

So, right after building this guide, I was tasked with adding Rubocop to another Rails repo. 

It took 1/10th the time this time around. Here's what I did:

add rubocop to gemfile

run `rubocop --auto-gen-config`, to get `.rubocop.yml` and `.rubocop_todo.yml`

Comment out `inherit_from: .rubocop_todo.yml` in the `.rubocop.yml`

Run `rubocop --format offenses` to get the output/violation counts.

4141 offenses

![first run](/images/quick-setup.jpg)

Added the following to my `.rubycop.yml`:

```
# excluding db/schema, as Rubocop thought a date (`2019_12_11_085215`)
# should be interpreted as a number
Style/NumericLiterals:
  Exclude:
    - 'db/schema.rb'            # 1 offense

# Single vs. double quote strings. Hard question to answer
# https://github.com/rubocop-hq/ruby-style-guide/issues/184
# But imposing any standard would touch 1442 lines of code; 
# too much history re-writing. 
Style/StringLiterals:
  Enabled: false                # 1321 offenses
```

Down to 2800 offenses. 🙌

Add a few more exclusions, based on the most common problems. I've investigated these cops, feel that the value of adhering to their preferences is low, relative to the cost of re-writing thousands of lines of code and messing with the git histories, etc.

Especially if, the app is already doing just what it needs to do, we can take a bit of a [Chesterton's Fence](https://fs.blog/2020/03/chestertons-fence/) approach, not modify something just because we're new on the scene. 

Added more exclusions:

```yml

Layout/HashAlignment:
  Enabled: false                # 305 offenses May 2020
# 
# Layout/LineLength:
#   Max: 140                      # 36 offenses May 2020

Layout/SpaceAroundOperators:
  Enabled: false                # 402 offenses May 2020
# 
Layout/SpaceInsideBlockBraces:
  Enabled: false                # 196 offenses May 2020
  
Style/Documentation:
  Enabled: false                # 196 offenses May 2020
# 
Style/FrozenStringLiteralComment:
  Enabled: false                # 259 offenses May 2020
  
  
# Rubocop wants modern {key: value} syntax, but we use hashrocket syntax for
# some rather funky keys, so saying "no mixed keys" feels good to me.
# example key that would cause a problem otherwise:
# :Legal_Full_Name__c=>IntakeSurveyResponse.params['legal_name']
Style/HashSyntax:
  EnforcedStyle: no_mixed_keys  # 331 instances, May 2020
```

Down to 1400 offenses. 



Now I'm seeing lots of `metrics` related warnings. Some are warn-level offenses, so they'll need to be fixed before this can clear a CircleCI config, others are not warn-level offenses. 

Here's what I see:

![metrics](/images/rubocop-metrics.jpg)

So, lets look at _just_ metrics-related Rubocop errors:

```
$ rubocop --only Metrics
```

But this generates some messy output. This screenshot is only some of the hundreds of lines of output:

![better metrics](/images/rubocop-better-metrics.jpg)

So, here's what I ended up using. The `--format` flag:


```
$ rubocop --only Metrics --format offenses
```

SO MUCH MORE READABLE!

![offenses](/images/rubocop-metrics-offenses.jpg)

We can get detailed, but still vastly simplified output if we use `--format simple`

```
$ rubocop --only Metrics --format simple
```

and here's what that output looks like:

![such amaze, much wow](/images/much-simpler-simple.jpg)

# Deploy-related gotchas

So, upon the deploy, ran into two problems.

### 1. extraneous `require` statements

Make sure you don't have `require 'rubocop'` in any of your rake tasks; Rake auto-loads the rake tasks, in a environment-related manner, and since Rubocop isn't used in prod, when you go to deploy in a `production` environment, that require statement will cause problems. 

### 2. Check your rake task availability in a production environment

A partial sanity check before deploying the code, to ensure that rake tasks are in good shape, is:

```
bundle exec rake -P RAILS_ENV=production
```

This won't catch _everything_ necessarily, but it'll help. I had to make two additional PRs, one for each of these two issues, after the large Rubocop PR, in order to get this code deployed. 



### Resources

- [Rubocop Docs: Basic Usage](https://docs.rubocop.org/en/stable/basic_usage/)
- [all Rubocop cops](https://github.com/rubocop-hq/rubocop/tree/master/lib/rubocop/cop)
- [Running Rubocop Only On Modified Files](https://medium.com/devnetwork/running-rubocop-only-on-modified-files-a21aed86e06d)
- [What is Rake in Ruby & How to Use it](https://www.rubyguides.com/2019/02/ruby-rake/)
- [RuboCop in legacy projects, part 1: TODOs and TODON’Ts](https://medium.com/@scottm/rubocop-in-legacy-projects-part-1-todos-and-todonts-877ace9f23b7)
- [RuboCop in legacy projects, part 2: Focus on the present](https://medium.com/@scottm/rubocop-in-legacy-projects-part-2-focus-on-the-present-8d3df0626a29)

https://github.com/AtomLinter/linter-rubocop
https://docs.rubocop.org/en/stable/integration_with_other_tools/