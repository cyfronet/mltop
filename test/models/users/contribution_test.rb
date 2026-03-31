require "test_helper"
require "active_support/testing/assertions"
class Users::ContributionTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess::FixtureFile
  include ActiveSupport::Testing::Assertions

  test "#all_hypothesis creates a zip with expected content" do
    user = create(:user)
    model1 = create(:model, owner: user)
    hypothesis1 = create(:hypothesis,
      test_set_entry: test_set_entries(:flores_st_en_pl),
      model: model1,
      input: fixture_file_upload("input.txt"))
    model2 = create(:model, tasks: [ tasks(:asr) ], owner: user)
    hypothesis2 = create(:hypothesis,
        test_set_entry: test_set_entries(:flores_asr_en_pl),
        model: model2,
        input: fixture_file_upload("ref.txt"))
    expected_filename1 = [ "user-#{user.id}", model1.tasks.first.name, model1.name, hypothesis1.test_set_entry.test_set.name, hypothesis1.test_set_entry.to_s ].join("/")
    expected_filename2 = [ "user-#{user.id}", model2.tasks.first.name, model2.name, hypothesis2.test_set_entry.test_set.name, hypothesis2.test_set_entry.to_s ].join("/")

    other_challenge = create(:challenge)
    other_task = create(:task, challenge: other_challenge)
    other_test_set = create(:test_set, challenge: other_challenge)
    other_task_test_set = create(:task_test_set, task: other_task, test_set: other_test_set)
    other_test_set_entry = create(:test_set_entry, task_test_set: other_task_test_set)
    other_challenge_model = create(:model, owner: user, challenge: other_challenge, tasks: [ other_task ])

    other_challenge_hypothesis = create(:hypothesis,
      test_set_entry: other_test_set_entry,
      model: other_challenge_model,
      input: fixture_file_upload("input.txt"))
    non_expected_filename = [ "user-#{user.id}", other_challenge_model.tasks.first.name, other_challenge_model.name, other_challenge_hypothesis.test_set_entry.test_set.name, other_challenge_hypothesis.test_set_entry.to_s ].join("/")

    zip_path = user.all_hypothesis(model1.challenge_id)

    assert File.exist?(zip_path)
    contents = []
    Zip::File.open(zip_path) do |zip_file|
      zip_file.each do |entry|
        contents << { name: entry.name.force_encoding("UTF-8"), contents: entry.get_input_stream.read }
      end
    end

    assert_equal 2, contents.size
    assert_equal "Model inputs", contents.first[:contents].chomp
    assert_equal contents.first[:name], expected_filename1
    assert_equal "Test set reference file", contents.second[:contents].chomp
    assert_equal contents.second[:name], expected_filename2
    assert_not contents.any? { |entry| entry[:name] == non_expected_filename }, "Zip file should not contain hypotheses from other challenges"
  end
end
