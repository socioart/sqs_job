require "sqs_job/client"
require "set"

module SqsJob
  class Worker < Client
    def initialize(*args, **kargs)
      super(*args, **kargs)
    end

    # rubocop:disable Lint/RescueException
    def listen(&block)
      logger.debug(type: "listen", queue_url: job_queue_url, wait_time_seconds: 20)
      loop do
        r = sqs.receive_message(
          queue_url: job_queue_url,
          wait_time_seconds: 20,
        )

        r.messages.each do |message|
          parsed = JSON.parse(message.body)
          logger.info(type: "received_message", message: parsed)

          job = Job.deserialize(JSON.parse(message.body))
          result = block.call(job)
          response(Response.new(job, result))

          logger.debug(type: "delete_message", queue_url: result_queue_url, receipt_handle: message.receipt_handle)
          sqs.delete_message(
            queue_url: job_queue_url,
            receipt_handle: message.receipt_handle,
          )
        end
      end
    rescue Exception
      logger.error(type: "unhandle_exception", class: $!.class.to_s, message: $!.message)
      raise $!
    end
    # rubocop:enable Lint/RescueException

    private
    def response(response)
      logger.info(type: "send_message", queue_url: result_queue_url, message_body: response.as_json)
      sqs.send_message(
        queue_url: result_queue_url,
        message_body: response.to_json,
      )
    end
  end
end
