require "json"

module SqsJob
  class Response
    attr_reader :job, :result

    # @param [Hash] h
    def self.deserialize(h)
      new(
        Job.deserialize(h.fetch("job")),
        h.fetch("result"),
      )
    end

    def initialize(job, result)
      @job = job
      @result = result
    end

    def as_json
      {
        job: job,
        result: result,
      }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
