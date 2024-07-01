require "test_helper"

class TestSetEntryTest < ActiveSupport::TestCase
  test "input file name" do
    entry = test_set_entries("flores_en")

    assert "FLORES--en.txt", entry.input_file_name
  end
end
