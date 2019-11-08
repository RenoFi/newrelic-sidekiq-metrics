require 'bundler/setup'
require 'pry'
require 'sidekiq/cli'
require 'newrelic-sidekiq-metrics'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end

  config.after(:each) do |example|
    NewrelicSidekiqMetrics.use(NewrelicSidekiqMetrics::DEFAULT_ENABLED_METRICS)
  end
end
