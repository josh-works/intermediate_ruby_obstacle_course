task default: [:test]
# require 'rubocop/rake_task'
# Add additional test suite definitions to the default test task here

task :apple do
  puts "eat more apples"
end

# from https://stackoverflow.com/a/34026868/3210178
# task :test do
#   desc 'Runs RuboCop on specified directories'
#   RuboCop::RakeTask.new(:rubocop) do |task|
#     # Dirs: app, lib, test
#     task.patterns = ['app/**/*.rb', 'lib/**/*.rb', 'test/**/*.rb']
# 
#     # Make it easier to disable cops.
#     task.options << "--display-cop-names"
# 
#     # Abort on failures (fix your code first)
#     task.fail_on_error = false
#   end
# end
# 
# Rake::Task[:test].enhance ['test:rubocop']


require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['nokogiri/*_test.rb']
  t.verbose = true
end