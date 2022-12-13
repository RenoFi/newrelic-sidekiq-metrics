RSpec.describe NewrelicSidekiqMetrics do
  describe '.available_metrics' do
    it do
      expect(described_class.available_metrics).to match_array(%i[processed failed scheduled_size retry_size dead_size enqueued processes_size workers_size])
    end
  end

  describe '.used_metrics' do
    it do
      expect(described_class.used_metrics).to match_array(%i[enqueued retry_size])

      described_class.use(:processed, :enqueued, :foo)

      expect(described_class.used_metrics).to match_array(%i[processed enqueued])
    end
  end

  describe '.add_client_middleware' do
    it do
      expect(Sidekiq.default_configuration.client_middleware.entries.map(&:klass)).to include(NewrelicSidekiqMetrics::Middleware)
    end
  end

  describe '.add_server_middleware' do
    it do
      expect(Sidekiq.default_configuration.server_middleware.entries.map(&:klass)).to include(NewrelicSidekiqMetrics::Middleware)
    end
  end
end
