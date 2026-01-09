require "test_helper"

class HypothesesBundles::ProcessorTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess::FixtureFile

  setup do
    @model = create(:model, tasks: [ tasks(:st), tasks(:asr) ])
    @hypotheses_bundle = HypothesesBundle.create(name: "test", model: @model, archive: fixture_file_upload("hypotheses_bundle.zip", "application/zip"))
  end

  test "should create hypotheses for valid zip structure" do
    assert_difference "@model.reload.hypotheses.count", 4 do
      HypothesesBundles::Processor.new(@hypotheses_bundle).process
    end
    @hypotheses_bundle.reload
    assert_equal "success", @hypotheses_bundle.state
    assert_nil @hypotheses_bundle.error_message
  end

  test "should not create hypotheses for invalid task" do
    @hypotheses_bundle.update(archive: fixture_file_upload("hypotheses_bundle_invalid_task.zip", "application/zip"))
    assert_no_difference "Hypothesis.count" do
      HypothesesBundles::Processor.new(@hypotheses_bundle).process
    end
    @hypotheses_bundle.reload
    assert_equal "failed", @hypotheses_bundle.state
    assert_equal "Invalid tasks: invalid task", @hypotheses_bundle.error_message
  end

  test "should not create hypotheses for invalid zip structure" do
    @hypotheses_bundle.update(archive: fixture_file_upload("hypotheses_bundle_invalid_structure.zip", "application/zip"))
    assert_no_difference "Hypothesis.count" do
      HypothesesBundles::Processor.new(@hypotheses_bundle).process
    end
    @hypotheses_bundle.reload
    assert_equal "failed", @hypotheses_bundle.state
    assert_equal "Submitted file is empty or has invalid structure", @hypotheses_bundle.error_message
  end

  test "should not create duplicate hypotheses" do
    assert_difference "@model.reload.hypotheses.count", 4 do
      HypothesesBundles::Processor.new(@hypotheses_bundle).process
    end

    assert_no_difference "Hypothesis.count" do
      HypothesesBundles::Processor.new(@hypotheses_bundle).process
    end
    @hypotheses_bundle.reload
    assert_equal "failed", @hypotheses_bundle.state
    assert_match "Hypothesis for this task and test set is already present", @hypotheses_bundle.error_message
  end
end
