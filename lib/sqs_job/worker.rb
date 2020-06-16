require "sqs_job/client"

module SqsJob
  class Worker < Client
    def listen(&block)
      loop do
        r = sqs.receive_message(
          queue_url: job_queue_url,
          wait_time_seconds: 20,
        )
        r.messages.each do |message|
          job = Job.deserialize(JSON.parse(message.body))
          result = block.call(job)
          response(job, result)
          sqs.delete_message(
            queue_url: job_queue_url,
            receipt_handle: message.receipt_handle,
          )
        end
      end
    end

    private
    def response(job, result)
      sqs.send_message(
        queue_url: result_queue_url,
        message_body: Response.new(job, result).to_json,
      )
    end
  end
end
