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

    zip_path = user.all_hypothesis

    assert File.exist?(zip_path)
    contents = []
    Zip::File.open(zip_path) do |zip_file|
      zip_file.each do |entry|
        contents << { name: entry.name.force_encoding("UTF-8"), contents: entry.get_input_stream.read }
      end
    end

    assert_equal "Model inputs", contents.first[:contents].chomp
    assert_equal contents.first[:name], expected_filename1
    assert_equal "Test set reference file", contents.second[:contents].chomp
    assert_equal contents.second[:name], expected_filename2
  end
end
