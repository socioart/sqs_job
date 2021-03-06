require "sqs_job/version"
require "aws-sdk-sqs"

module SqsJob
  class Error < StandardError; end
  # Your code goes here...
end

require "sqs_job/job"
require "sqs_job/logger"
require "sqs_job/manager"
require "sqs_job/response"
require "sqs_job/worker"
