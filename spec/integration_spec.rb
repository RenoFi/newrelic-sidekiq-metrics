class HelloWorker
  include Sidekiq::Worker

  def perform(arg)
    arg
  end
end

RSpec.describe 'Sidekiq Integration', type: :integration do
  describe 'HelloWorker.perform_async(1)' do
    subject { HelloWorker.perform_async(1) }

    it 'HelloWorker receives :new, :perform with 1' do
      instance = HelloWorker.new
      expect(HelloWorker).to receive(:new) { instance }
      expect(instance).to receive(:perform).with(1)
      subject
    end
  end
end
