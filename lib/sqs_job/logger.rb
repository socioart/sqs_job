require "forwardable"
require "logger"
require "json"

module SqsJob
  class Logger
    extend Forwardable
    delegate [:debug, :error, :fatal, :info] => :@logger

    def initialize(io = $stdout)
      @logger = ::Logger.new(io)
      @logger.formatter = -> (severity, time, _progname, message) {
        message.merge(severity: severity, time: time.to_f).to_json + "\n"
      }
    end
  end
end
