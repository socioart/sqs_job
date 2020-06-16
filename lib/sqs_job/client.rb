module SqsJob
  class Client
    attr_reader :queue_prefix, :sqs, :logger

    def initialize(queue_prefix, aws_credentials, logger: Logger.new)
      @queue_prefix = queue_prefix.dup.freeze
      @sqs = Aws::SQS::Client.new(aws_credentials)
      @logger = logger
    end

    def job_queue_url
      @job_queue_url ||= get_or_create_queue(queue_prefix + "_job")
    end

    def result_queue_url
      @result_queue_url ||= get_or_create_queue(queue_prefix + "_result")
    end

    private
    def get_or_create_queue(name)
      q = sqs.get_queue_url(queue_name: name).queue_url
      logger.info(type: "get_queue", name: name, url: q)
      q
    rescue Aws::SQS::Errors::NonExistentQueue
      q = sqs.create_queue(queue_name: name).queue_url
      logger.info(type: "create_queue", name: name, url: q)
      q
    end
  end
end
