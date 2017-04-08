require 'cucumber'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'rake/clean'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass') do |t|
  exempt_tags = ["--tags ~@wip"]
  t.cucumber_opts = "--color #{exempt_tags.join(" ")} --strict --verbose --backtrace"
end

task test: %w(cucumber spec)
task default: :test
