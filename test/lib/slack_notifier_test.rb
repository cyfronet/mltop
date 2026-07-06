require "test_helper"
require "webmock/minitest"

class SlackNotifierTest < ActiveSupport::TestCase
  WEBHOOK_URL = SlackNotifier::WEBHOOK_URL

  setup do
    @owner = users(:marek)
    @model = build(:model, owner: @owner, name: "my-model", challenge_id: SlackNotifier::NOTIFIABLE_CHALLENGE_IDS.first)
    skip # to test it, disable guard clause in SlackNotifier.send_new_submission_notification for prod and comment out the skip here
  end

  def stub_slack(status: 200, body: "ok")
    stub_request(:post, WEBHOOK_URL).to_return(status:, body:)
  end

  test "posts a notification for a notifiable challenge" do
    stub = stub_slack
    SlackNotifier.send_new_submission_notification(@model)

    assert_requested stub
  end

  test "payload contains model name and owner email" do
    stub = stub_slack.with(
      headers: { "Content-Type" => "application/json" },
      body: ->(body) {
        parsed = JSON.parse(body, symbolize_names: true)
        fields = parsed[:attachments].first[:fields]
        fields.any? { |field| field[:title] == "Model" && field[:value] == @model.name } &&
        fields.any? { |field| field[:title] == "Owner" && field[:value] == @owner.email }
      }
    )

    SlackNotifier.send_new_submission_notification(@model)

    assert_requested stub
  end

  test "skips notification for non-notifiable challenge" do
    @model.challenge_id = -1

    SlackNotifier.send_new_submission_notification(@model)

    assert_not_requested :post, WEBHOOK_URL
  end

  test "logs error and does not raise on network failure" do
    stub_request(:post, WEBHOOK_URL).to_raise(StandardError.new("connection refused"))

    Rails.logger.expects(:error).with { "Failed to send notification for model #{@model.id}" }

    SlackNotifier.send_new_submission_notification(@model)
  end
end
