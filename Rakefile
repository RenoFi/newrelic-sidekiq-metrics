require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'newrelic_sidekiq_metrics'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %w[spec rubocop:auto_correct]
