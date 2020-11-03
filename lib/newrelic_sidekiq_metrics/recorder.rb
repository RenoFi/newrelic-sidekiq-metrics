module NewrelicSidekiqMetrics
  class Recorder
    attr_reader :metrics

    def initialize
      @metrics = NewrelicSidekiqMetrics.used_metrics
    end

    def call
      metrics.each { |m| record_metric(m) }
    end

    def stats
      @stats ||= Sidekiq::Stats.new

    end

    private

    def record_metric(name)
      NewRelic::Agent.record_metric(metric_full_name(name), stats.public_send(name))
    end

    def metric_full_name(name)
      File.join(NewrelicSidekiqMetrics.used_prefix, METRIC_MAP.fetch(name))
    end
  end
end
