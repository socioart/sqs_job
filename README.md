# SqsJob

Master-Worker style job processing framework with Amazon SQS.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "sqs_job", git: "https://github.com/socioart/sqs_job.git"
```

And then execute:

    $ bundle install


## Usage

### Create job (on Master)

    m = SqsJob::Master.new("test_queue", aws_credentials)
    m.add(SqsJob::Job.new("foo", {bar: rand(0..127)}))

### Receive and processing job (on Worker)

    w = SqsJob::Worker.new("test_queue", aws_credentials)
    w.listen do |job|
      # Processing job and return result
      job.attributes["bar"] * 2
    end

### Receive result (on Master)

    m = SqsJob::Master.new("test_queue", aws_credentials)
    m.listen do |response|
      p response.job
      p response.result
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/labocho/sqs_job.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
