# frozen_string_literal: true

class ActiveSupport::TestCase
  include FixtureFactory::Registry
  include FixtureFactory::Methods

  define_factories do
    factory(:model) do |count|
      {
        owner: users("marek"),
        name: "model#{count}",
        tasks: [ tasks("st") ]
      }
    end

    factory(:hypothesis) do
      {
        groundtruth: groundtruths("flores_en_pl_st"),
        input: { io: StringIO.new("hypothesis"), filename: "hypothesis.txt" }
      }
    end

    factory(:evaluation) do
      {
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
        to: "text"
      }
    end
  end
end
