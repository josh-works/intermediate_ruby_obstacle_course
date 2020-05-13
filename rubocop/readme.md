# Rubocop Obstacle Course

It's very common to have to add/work with Rubocop on Rails apps.

Lets quickly get _your_ knowledge up and running, so with an hour or two of work, you'll be the local Rubocop expert!

Steps so far:

1. Add Rubocop to Gemfile 
2. Add/configure `.rubocop.yml` to project root
3. Set useful starting points, cops, warning levels, etc.

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



### Resources

- [Rubocop Docs: Basic Usage](https://docs.rubocop.org/en/stable/basic_usage/)