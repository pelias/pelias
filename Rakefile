require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

task :default => :spec
task :test => :spec

Dir.glob('lib/pelias/tasks/*.rake').each {|r| import r}
