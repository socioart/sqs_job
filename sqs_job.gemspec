require_relative "lib/sqs_job/version"

Gem::Specification.new do |spec|
  spec.name          = "sqs_job"
  spec.version       = SqsJob::VERSION
  spec.authors       = ["labocho"]
  spec.email         = ["labocho@penguinlab.jp"]

  spec.summary       = "Manager-Worker style job processing framework with Amazon SQS"
  spec.description   = "Manager-Worker style job processing framework with Amazon SQS"
  spec.homepage      = "https://github.com/socioart/sqs_job"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/socioart/sqs_job"
  spec.metadata["changelog_uri"] = "https://github.com/socioart/sqs_job/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r(^exe/)) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-sqs", "~> 1.27"
end
