require "test_helper"

class TestSetEntryTest < ActiveSupport::TestCase
  test "input file name" do
    entry = test_set_entries("flores_st_en_pl")

    assert "FLORES--en-pl.txt", entry.input_file_name
  end
end
