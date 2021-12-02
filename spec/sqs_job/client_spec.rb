RSpec.describe SqsJob::Client do
  let(:sqs_client) { Aws::SQS::Client.new(stub_responses: true) }
  it "has a version number" do
    expect(SqsJob::VERSION).not_to be nil
  end
end
