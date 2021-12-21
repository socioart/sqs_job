require "sqs_job/client"

module SqsJob
  class Manager < Client
    # @return [SqsJob::Job]
    def add_job(name, attributes = {})
      job = Job.new(name, attributes)
      logger.info(type: "send_message", queue_url: job_queue_url, message_body: job.as_json)
      sqs.send_message(
        queue_url: job_queue_url,
        message_body: job.to_json,
      )
      job
    end

    # rubocop:disable Lint/RescueException
    def listen(&block)
      logger.debug(type: "listen", queue_url: result_queue_url, wait_time_seconds: 20)
      loop do
        r = sqs.receive_message(
          queue_url: result_queue_url,
          wait_time_seconds: 20,
        )

        r.messages.each do |message|
          parsed = JSON.parse(message.body)
          logger.info(type: "received_message", message: parsed)

          response = Response.deserialize(parsed)
          block.call(response)

          logger.debug(type: "delete_message", queue_url: result_queue_url, receipt_handle: message.receipt_handle)
          sqs.delete_message(
            queue_url: result_queue_url,
            receipt_handle: message.receipt_handle,
          )
        end
      end
    rescue Exception
      logger.error(type: "unhandle_exception", class: $!.class.to_s, message: $!.message)
      raise $!
    end
    # rubocop:enable Lint/RescueException
  end
end
