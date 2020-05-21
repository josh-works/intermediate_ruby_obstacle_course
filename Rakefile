require 'rubocop/rake_task'

task default: [:test]
# require 'rubocop/rake_task'

desc 'Run RuboCop on the lib directory'
RuboCop::RakeTask.new(:rubocop) do |task|
  # task.patterns = ['lib/**/*.rb']
  task.patterns = ['./nokogiri/nokogiri_test.rb']
  # only show the files with failures
  # task.formatters = ['files']
  # don't abort rake on failure
  task.fail_on_error = true
end

require 'rake/testtask'
desc 'run all tests'
task :test do
  Rake::Task['rubocop'].invoke

  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['nokogiri/*_test.rb']
    t.verbose = true
  end
end


# running "rake rubocop" after all test runs, to help catch any errors
# before pushing to github and having CircleCI throw an error.
# Rake::Task['mrspec'].enhance do
#   Rake::Task['rubocop'].invoke
# end


require 'rubocop/rake_task'

task(:rubocop)
desc 'Run RuboCop on changed files'
RuboCop::RakeTask.new(:rubocop) do |task|
  exec(' git ls-files -m | xargs ls -1 2>/dev/null | grep "\.rb$" | xargs rubocop --format simple')
  # only show the files with failures
  # task.formatters = ['files']
  # don't abort rake on failure
  task.fail_on_error = false
end
