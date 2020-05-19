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
  Rake::Task["rubocop"].invoke
  
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['nokogiri/*_test.rb']
    t.verbose = true
  end
end


