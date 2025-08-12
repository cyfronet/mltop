# frozen_string_literal: true

class ActiveSupport::TestCase
  include FixtureFactory::Registry
  include FixtureFactory::Methods

  define_factories do
    factory(:user) do |count|
      {
        name: "User#{count}",
        email: "user#{count}@mltop.local",
        plgrid_login: "plguser#{count}",
        uid: "uid-user#{count}"
      }
    end

    factory(:model) do |count|
      {
        owner: users("marek"),
        name: "model#{count}",
        tasks: [ tasks("st") ],
        challenge: challenges(:global)
      }
    end

    factory(:hypothesis) do
      {
        test_set_entry: test_set_entries("flores_st_en_pl"),
        input: { io: StringIO.new("hypothesis"), filename: "hypothesis.txt" },
        model: build(:model)
      }
    end

    factory(:evaluation) do
      {
        creator: users("marek"),
        hypothesis: build(:hypothesis),
        evaluator: evaluators(:blueurt)
      }
    end

    factory(:score) do
      {
        evaluation: build(:evaluation),
        metric: metrics(:blueurt),
        value: Random.rand(100)
      }
    end

    factory(:task) do |i|
      {
        name: "Task #{i}",
        slug: "task#{i}",
        from: "video",
        to: "text",
        challenge: challenges(:global)
      }
    end

    factory(:test_set) do |i|
      {
        name: "Test set #{i}",
        challenge: challenges(:global)
      }
    end

    factory(:test_set_entry) do |i|
      {
        source_language: "en",
        target_language: "pl",
        groundtruth: Rack::Test::UploadedFile.new(StringIO.new("input"), "text/plain", original_filename: "input.txt"),
        input: Rack::Test::UploadedFile.new(StringIO.new("input"), "text/plain", original_filename: "input.txt")
    }
    end

    factory(:evaluator) do |i|
      {
        name: "Evaluator #{i}",
        host: "host",
        script: "script",
        challenge: challenges(:global)
      }
    end

    factory(:challenge) do |i|
      {
        name: "Challenge #{i}",
        starts_at: 5.days.ago,
        ends_at: 5.days.from_now,
        description: "some description",
        owner: users(:marek)
      }
    end

    factory(:consent) do |i|
      {
        name: "consent #{i}",
        description: "some description",
        challenge: challenges(:global),
        target: "challenge"
      }
    end

    factory(:membership) do |i|
      {
        user: users(:marek),
        challenge: challenges(:global)
      }
    end

    factory(:access_rule) do |i|
      {
        challenge: challenges(:global),
        group_name: "name #{i}",
        roles: :participant
      }
    end
  end
end
