module NewrelicSidekiqMetrics
  class ClientMiddleware
    def call(_worker, _msg, _queue, _redis)
      Recorder.new.call
      yield
    end
  end
end
