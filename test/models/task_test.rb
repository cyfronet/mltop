require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "#with_published_test_sets" do
    st = Task.with_published_test_sets.find(tasks(:st).id)

    assert_equal test_sets(:flores, :mustc), st.test_sets.to_a
  end
end
