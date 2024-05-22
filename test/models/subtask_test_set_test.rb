require "test_helper"

class SubtaskTestSetTest < ActiveSupport::TestCase
  test "input file name" do
    subtask_test_set = subtask_test_sets("flores_en_pl")

    assert "FLORES--en-to-pl.txt", subtask_test_set.input_file_name
  end
end
