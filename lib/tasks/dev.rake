if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task seed: "db:setup" do
      t2t = Task.find_or_create_by(name: "Automatic Speech Recognition (ASR)", from: :audio, to: :text)
      t2m = Task.find_or_create_by(name: "Speech-to-text Translation (ST)", from: :audio, to: :text)
      m2m = Task.find_or_create_by(name: "Machine (text-to-text) Translation (MT)", from: :text, to: :text)
      m2t = Task.find_or_create_by(name: "Lip Reading (LR)", from: :movie, to: :text)

      [ t2t, t2m, m2m, m2t ].each do |type|
        sacrebleu = type.benchmarks.find_or_create_by(name: "Sacrebleu")
        sacrebleu.metrics.find_or_create_by(name: "blue")
        sacrebleu.metrics.find_or_create_by(name: "chrf")
        sacrebleu.metrics.find_or_create_by(name: "ter")

        bleurt = type.benchmarks.find_or_create_by(name: "bleurt")
        bleurt.metrics.find_or_create_by(name: "bleurt")

        metrics = type.benchmarks.flat_map(&:metrics)

        100.times do |i|
          model = type.models.create(name: "#{type.name} model #{i + 1}")
          metrics.each do |metric|
            model.scores.create(metric:, value: Random.rand(100))
          end
        end
      end
    end
  end
end
