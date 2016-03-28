require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'rake/clean'

RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:cucumber, 'Run features that should pass')

task test: %w('cucumber spec')
task default: :test
