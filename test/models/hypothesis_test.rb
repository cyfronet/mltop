require "test_helper"

class HypothesisTest < ActiveSupport::TestCase
  test "cannot create hypothesis without input" do
    model = create(:model)
    groundtruth = groundtruths("flores_en_pl_st")

    assert_not Hypothesis.new(model:, groundtruth:).valid?
    assert Hypothesis.new(model:, groundtruth:, input: upload_file).valid?
  end

  private
    def upload_file
      { io: StringIO.new("input"), filename: "input.txt" }
    end
end
