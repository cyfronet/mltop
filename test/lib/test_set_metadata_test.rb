require "test_helper"

class TestSetMetadataTest < ActiveSupport::TestCase
  setup do
    @metadata = TestSetMetadata.new(
      file_fixture("tasks.yml"), file_fixture("test_sets.yml"))
  end

  test "test set description from fixture file" do
    assert_equal "FLORES description", @metadata.description("FLORES")
    assert_nil @metadata.description("NonExistentTestSet")
  end

  test "#skip?" do
    assert @metadata.skip?("NonExistingTasks", "FLORES")
    assert @metadata.skip?("MT", "Other")
    assert @metadata.skip?("MT", "FLORES", "pl-en")

    assert_not @metadata.skip?("MT", "FLORES", "en-de")
  end
end
