module NewrelicSidekiqMetrics
  class Recorder
    attr_reader :metrics

    def initialize
      @metrics = NewrelicSidekiqMetrics.used_metrics
    end

    def call
      metrics.each { |m| record_metric(m) }
    end

    private

    def stats
      @stats = JSON.parse(Sidekiq::Stats.new.to_json, {:symbolize_names => true})[:stats].with_indifferent_access
      queues = Sidekiq::Queue.all
      queues.each {|queue| @stats["#{queue.name}_latency".to_sym] = queue.latency}
      @stats[:queue_latency_total] = Sidekiq::Queue.all.inject(0) { |sum, i| sum + Sidekiq::Queue.new(i.name).latency }
      @stats
    end

    def get_stat(name)
      return 0 if NewrelicSidekiqMetrics.inline_sidekiq?

      stats.public_send(name)
    end

    def record_metric(name)
      begin
        NewRelic::Agent.record_metric(metric_full_name(name), stats[name])
      rescue 
        return 
      end
    end

    def metric_full_name(name)
      File.join(NewrelicSidekiqMetrics.used_prefix, METRIC_MAP.fetch(name))
    end
  end
end
