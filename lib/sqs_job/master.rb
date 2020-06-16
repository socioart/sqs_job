require "sqs_job/client"

module SqsJob
  class Master < Client
    def add(job)
      sqs.send_message(
        queue_url: job_queue_url,
        message_body: job.to_json,
      )
    end

    def listen(&block)
      loop do
        r = sqs.receive_message(
          queue_url: result_queue_url,
          wait_time_seconds: 20,
        )
        r.messages.each do |message|
          response = Response.deserialize(JSON.parse(message.body))
          block.call(response)
          sqs.delete_message(
            queue_url: result_queue_url,
            receipt_handle: message.receipt_handle,
          )
        end
      end
    end
  end
end
