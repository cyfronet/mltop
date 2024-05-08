# frozen_string_literal: true

class ActiveSupport::TestCase
  include FixtureFactory::Registry
  include FixtureFactory::Methods

  define_factories do
    factory(:model) do |count|
      {
        name: "model#{count}",
        tasks: [ tasks("st") ]
      }
    end

    factory(:evaluation) do
      {
        model: create(:model),
        evaluator: evaluators(:blueurt),
        subtask_test_set: subtask_test_sets(:flores_en_pl)
      }
    end

    factory(:score) do
      {
        evaluation: create(:evaluation),
        metric: metrics(:blueurt),
        value: Random.rand(100)
      }
    end
  end
end
