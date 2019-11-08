RSpec.describe NewrelicSidekiqMetrics::Recorder do
  describe '#call' do
    before do
      NewrelicSidekiqMetrics.use(:enqueued, :workers_size)
    end

    it do
      expect(NewRelic::Agent).to receive(:record_metric).with('Custom/Sidekiq/EnqueuedSize', 0).and_call_original
      expect(NewRelic::Agent).to receive(:record_metric).with('Custom/Sidekiq/WorkersSize', 0).and_call_original

      subject.call
    end
  end
end
