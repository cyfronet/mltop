require "test_helper"

class ModelTest < ActiveSupport::TestCase
  test "model needs to belong to at least one task" do
    model = build(:model, tasks: [])

    assert_not model.valid?
  end
end
