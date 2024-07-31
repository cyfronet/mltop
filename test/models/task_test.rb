require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "filter groundtruths by test set" do
    st = tasks("st")
    test_set = test_sets("flores")

    groundtruths = st.groundtruths.by_test_set(test_set)

    assert_equal 2, groundtruths.size
    assert_equal groundtruths("flores_en_pl_st", "flores_en_it_st"), groundtruths
  end
end
