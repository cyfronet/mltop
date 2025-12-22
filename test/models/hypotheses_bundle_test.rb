require "test_helper"

class HypothesesBundleTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionDispatch::TestProcess::FixtureFile

  setup do
    @model = create(:model)
    @hypotheses_bundle = HypothesesBundle.create(name: "test", model: @model, archive: fixture_file_upload("hypotheses_bundle.zip", "application/zip"))
  end

  test "enqueues processing job" do
    assert_enqueued_jobs 1, only: ::HypothesesBundles::ProcessJob do
      @hypotheses_bundle.process_later
    end
  end
end
