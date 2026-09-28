require "test_helper"
class Evaluation::ScriptTest < ActiveSupport::TestCase
  setup do
    @evaluation = create(:evaluation)
    @token = "test-token-abc"
    @script = Evaluation::Script.new(@evaluation, @token)
    @env = @script.to_h.dig(:job, :environment)
  end

  test "INPUT_URL is passed as an ENV variable" do
    assert_includes @env, "INPUT_URL=#{blob_url(@evaluation.hypothesis.test_set_entry.input)}"
  end

  test "GROUNDTRUTH_URL is passed as an ENV variable" do
    assert_includes @env, "GROUNDTRUTH_URL=#{blob_url(@evaluation.hypothesis.test_set_entry.groundtruth)}"
  end

  test "HYPOTHESIS_URL is passed as an ENV variable" do
    assert_includes @env, "HYPOTHESIS_URL=#{blob_url(@evaluation.hypothesis.input)}"
  end

  test "INTERNAL_URL is passed as an ENV variable when internal is attached" do
    @evaluation.hypothesis.test_set_entry.internal.attach(
      io: StringIO.new("data"),
      filename: "internal.txt",
      content_type: "text/plain"
    )
    script = Evaluation::Script.new(@evaluation, @token)
    env = script.to_h.dig(:job, :environment)

    assert_includes env, "INTERNAL_URL=#{blob_url(@evaluation.hypothesis.test_set_entry.internal)}"
  end

  test "INTERNAL_URL is absent when internal is not attached" do
    @evaluation.internal.detach if @evaluation.hypothesis.test_set_entry.internal.attached?
    script = Evaluation::Script.new(@evaluation, @token)
    env = script.to_h.dig(:job, :environment)

    assert_nil env.find { |e| e.start_with?("INTERNAL_URL=") }
  end

  test "RESULTS_URL is passed as an ENV variable" do
    assert_includes @env, "RESULTS_URL=#{@script.send(:results_upload_url)}"
  end

  test "SOURCE_LANGUAGE is passed as an ENV variable" do
    assert_includes @env, "SOURCE_LANGUAGE=#{@evaluation.hypothesis.test_set_entry.source_language}"
  end

  test "TARGET_LANGUAGE is passed as an ENV variable" do
    assert_includes @env, "TARGET_LANGUAGE=#{@evaluation.hypothesis.test_set_entry.target_language}"
  end

  test "TOKEN is passed as an ENV variable" do
    assert_includes @env, "TOKEN=#{@token}"
  end

  test "TASK is passed as an ENV variable" do
    assert_includes @env, "TASK=#{@evaluation.hypothesis.test_set_entry.task.slug}"
  end

  test "USER_ID is passed as an ENV variable" do
    assert_includes @env, "USER_ID=#{@evaluation.hypothesis.model.owner_id}"
  end

  test "TEST_SET is passed as an ENV variable" do
    assert_includes @env, "TEST_SET=#{@evaluation.hypothesis.test_set_entry.test_set}"
  end

  test "MODEL is passed as an ENV variable" do
    assert_includes @env, "MODEL=#{@evaluation.hypothesis.model}"
  end

  private
    def blob_url(blob)
      Rails.application.routes.url_helpers.rails_blob_url(blob, default_url_options)
    end

    def default_url_options
      Rails.application.config.action_mailer.default_url_options
        .merge(script_name: "/#{ChallengeSlug.encode(@evaluation.send(:challenge).id)}")
    end
end
