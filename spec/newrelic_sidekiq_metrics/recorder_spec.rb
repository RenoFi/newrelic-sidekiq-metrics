RSpec.describe NewrelicSidekiqMetrics::Recorder do
  describe '#call' do
    context 'with inline sidekiq mode' do
      around do |example|
        Sidekiq::Testing.inline! do
          example.run
        end
      end

      specify do
        expect(NewrelicSidekiqMetrics.inline_sidekiq?).to eq(true)

        NewrelicSidekiqMetrics.use(:enqueued, :workers_size)

        expect(Sidekiq::Stats).not_to receive(:new)
        expect(NewRelic::Agent).to receive(:record_metric).with('Custom/Sidekiq/EnqueuedSize', 0).and_call_original
        expect(NewRelic::Agent).to receive(:record_metric).with('Custom/Sidekiq/WorkersSize', 0).and_call_original

        subject.call
      end
    end

    context 'with default sidekiq mode' do
      let(:stats) { instance_double(Sidekiq::Stats, enqueued: 4, workers_size: 2) }

      specify do
        expect(NewrelicSidekiqMetrics.inline_sidekiq?).to eq(false)

        NewrelicSidekiqMetrics.use(:enqueued, :workers_size)

        expect(Sidekiq::Stats).to receive(:new) { stats }
        expect(NewRelic::Agent).to receive(:record_metric).with('Custom/Sidekiq/EnqueuedSize', 4).and_call_original
        expect(NewRelic::Agent).to receive(:record_metric).with('Custom/Sidekiq/WorkersSize', 2).and_call_original

        subject.call
      end
    end
  end
end
