# from https://stackoverflow.com/a/34026868/3210178
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