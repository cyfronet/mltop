require "test_helper"

class ModelTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get model_types_url
    assert_response :success
  end

  test "should show model_type" do
    get model_type_url(model_types(:text_to_text))
    assert_response :success
  end
end