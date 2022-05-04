require 'sidekiq/api'
require 'newrelic_rpm'
require 'newrelic_sidekiq_metrics/version'
require 'newrelic_sidekiq_metrics/recorder'
require 'newrelic_sidekiq_metrics/middleware'

module NewrelicSidekiqMetrics
  METRIC_PREFIX = 'Custom/Sidekiq'.freeze

  METRIC_MAP = {
    processed: 'ProcessedSize',
    failed: 'FailedSize',
    scheduled_size: 'ScheduledSize',
    retry_size: 'RetrySize',
    dead_size: 'DeadSize',
    enqueued: 'EnqueuedSize',
    processes_size: 'ProcessesSize',
    workers_size: 'WorkersSize',
    default_queue_latency: 'DefaultQueueLatency',
    queue_latency_total: 'TotalQueueLatency',
    critical_fast_latency: 'CriticalFastLatency',
    critical_long_latency: 'CriticalLongLatency',
    important_latency: 'ImportantLatency',
    batches_latency: 'BatchesLatency',
    searchkick_latency: 'SearchkickLatency',
    long_latency: 'LongLatency',
    low: 'LowLatency',
  }.freeze

  DEFAULT_ENABLED_METRICS = %i[enqueued retry_size].freeze

  def self.available_metrics
    METRIC_MAP.keys
  end

  def self.used_metrics
    @used_metrics ||= DEFAULT_ENABLED_METRICS
  end

  def self.use(*values)
    @used_metrics = values.flatten & available_metrics
  end

  def self.used_prefix
    @used_prefix ||= METRIC_PREFIX
  end

  def self.set_prefix(value)
    @used_prefix = value
  end

  def self.add_client_middleware
    Sidekiq.configure_client do |config|
      config.client_middleware do |chain|
        chain.add NewrelicSidekiqMetrics::Middleware
      end
    end
  end

  def self.add_server_middleware
    Sidekiq.configure_server do |config|
      config.client_middleware do |chain|
        chain.add NewrelicSidekiqMetrics::Middleware
      end
      config.server_middleware do |chain|
        chain.add NewrelicSidekiqMetrics::Middleware
      end
    end
  end

  def self.inline_sidekiq?
    defined?(Sidekiq::Testing) && Sidekiq::Testing.inline?
  end
end

NewrelicSidekiqMetrics.add_client_middleware
NewrelicSidekiqMetrics.add_server_middleware
