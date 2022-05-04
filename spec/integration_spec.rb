class HelloService
  def self.call(arg)
  end
end

class HelloWorker
  include Sidekiq::Worker

  def perform(arg)
    HelloService.call(arg)
  end
end

RSpec.describe 'Sidekiq Integration', type: :integration do
  describe 'HelloWorker.perform_async' do
    let(:arg) { SecureRandom.hex }

    it 'executes instance with given arg' do
      expect(HelloService).to receive(:call).with(arg)

      Sidekiq::Testing.inline! do
        HelloWorker.perform_async(arg)
      end
    end
  end
end
