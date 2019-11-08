module NewrelicSidekiqMetrics
  class ServerMiddleware
    def call(_worker, _msg, _queue, &_block)
      Recorder.new.call
    end
  end
end
