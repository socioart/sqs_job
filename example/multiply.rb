require "sqs_job"

queue_prefix = "sqs_job_test"
credentials = {profile: ENV["AWS_PROFILE"], region: "ap-northeast-1"}

case ARGV.first
when "manager"
  m = SqsJob::Manager.new(queue_prefix, credentials, manager_id: "multiply")
  m.listen do |response|
    puts "response received (#{Time.now.iso8601(3)})"
    pp response
  end
when "worker"
  m = SqsJob::Worker.new(queue_prefix, credentials, manager_ids: %w(multiply))
  m.listen do |job|
    puts "job received (#{Time.now.iso8601(3)})"
    pp job
    r = job.attributes["number"] * 2
    puts "return #{r}"
    r
  end
else
  m = SqsJob::Manager.new(queue_prefix, credentials, manager_id: "multiply")
  m.add_job("multiply", {number: rand(0..127)})
end
