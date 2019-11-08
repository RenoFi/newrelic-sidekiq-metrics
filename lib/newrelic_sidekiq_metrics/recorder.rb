module NewrelicSidekiqMetrics
  class Recorder
    attr_reader :stats, :metrics

    def initialize
      @stats = Sidekiq::Stats.new
      @metrics = NewrelicSidekiqMetrics.enabled_metrics
    end

    def call
      metrics.each { |m| record_metric(m) }
    end

    private

    def record_metric(name)
      NewRelic::Agent.record_metric(metric_full_name(name), stats.public_send(name))
    end

    def metric_full_name(name)
      File.join(METRIC_PREFIX, METRIC_MAP.fetch(name))
    end
  end
end
