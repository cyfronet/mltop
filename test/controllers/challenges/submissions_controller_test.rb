require "test_helper"

module Challenges
  class SubmissionsControllerTest < ActionDispatch::IntegrationTest
    def setup
      sign_in_as("marek")
      in_challenge!(users("marek"))
    end

    test "show user models" do
      get submissions_path
      assert_response :success
    end

    test "create new submission" do
      assert_difference "Model.count", 1 do
        post submissions_path, params: {
          model: { name: "new model", task_ids: [ tasks("st").id, tasks("asr").id ] }
        }
        assert_response :redirect
      end

      model = Model.last

      assert_equal model.owner, users("marek")
      assert_equal "new model", model.name
      assert_equal [ tasks("asr"), tasks("st") ].map(&:id).sort, model.task_ids.sort
    end

    test "fails to create new submission with missing consents" do
      consent = create(:consent, target: "model", mandatory: true)
      assert_no_difference "Model.count" do
        post submissions_path, params: {
          model: { name: "new model", task_ids: [ tasks("st").id, tasks("asr").id ], agreements_attributes: [ { consent_id: consent.id, agreed: "0" } ] }
        }
      end
      assert_response :unprocessable_entity
    end

    test "create new submission with marked agreement" do
      consent = create(:consent, target: "model", mandatory: true)
      assert_difference "Agreement.count", 1 do
        assert_difference "Model.count", 1 do
          post submissions_path, params: {
            model: { name: "new model", task_ids: [ tasks("st").id, tasks("asr").id ], agreements_attributes: [ { consent_id: consent.id, agreed: "1" } ] }
          }
          assert_response :redirect
        end
      end
    end

    test "update model" do
      model = create(:model, owner: users(:marek))

      put submission_path(model), params: {
        model: { name: "new name", task_ids: [ tasks("asr").id ] }
      }
      assert_response :redirect

      model.reload
      assert_equal "new name", model.name
      assert_equal [ tasks("asr") ], model.tasks
    end

    test "unable to update other user model" do
      model = create(:model, owner: users(:szymon))

      put submission_path(model), params: {
        model: { name: "new name", task_ids: [ tasks("asr").id ] }
      }
      assert_response :not_found
    end
  end
end
