require "application_system_test_case"

class ModelTypesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit model_types_url
    assert_selector "h1", text: "Model types"
  end
end
