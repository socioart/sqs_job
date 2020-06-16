module SqsJob
  class Client
    attr_reader :queue_prefix, :sqs

    def initialize(queue_prefix, aws_credentials)
      @queue_prefix = queue_prefix.dup.freeze
      @sqs = Aws::SQS::Client.new(aws_credentials)
    end

    def job_queue_url
      @job_queue_url ||= get_or_create_queue(queue_prefix + "_job")
    end

    def result_queue_url
      @result_queue_url ||= get_or_create_queue(queue_prefix + "_result")
    end

    private
    def get_or_create_queue(name)
      sqs.get_queue_url(queue_name: name).queue_url
    rescue Aws::SQS::Errors::NonExistentQueue
      sqs.create_queue(queue_name: name).queue_url
    end
  end
end
