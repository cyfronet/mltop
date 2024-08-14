require "test_helper"

class HypothesisTest < ActiveSupport::TestCase
  test "cannot create hypothesis without input" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")

    assert_not Hypothesis.new(model:, test_set_entry:).valid?
    assert Hypothesis.new(model:, test_set_entry:, input: upload_file).valid?
  end

  test "cannot create two hypothesis with same test_set_entry and model" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")

    Hypothesis.create(model:, test_set_entry:, input: upload_file)
    assert_not Hypothesis.new(model:, test_set_entry:, input: upload_file).valid?
  end

  private
    def upload_file
      { io: StringIO.new("input"), filename: "input.txt" }
    end
end
