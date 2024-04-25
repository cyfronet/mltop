if Rails.env.local?
  namespace :dev do
    desc "Sample data for local development environment"
    task seed: "db:setup" do
      t2t = ModelType.find_or_create_by(name: "Text to text", from: :text, to: :text)
      ModelType.find_or_create_by(name: "Text to movie", from: :text, to: :movie)
      ModelType.find_or_create_by(name: "Movie to movie", from: :movie, to: :movie)
      ModelType.find_or_create_by(name: "Movie to text", from: :movie, to: :text)

      sacrebleu = t2t.benchmarks.find_or_create_by(name: "Sacrebleu")
      sacrebleu.metrics.find_or_create_by(name: "blue")
      sacrebleu.metrics.find_or_create_by(name: "chrf")
      sacrebleu.metrics.find_or_create_by(name: "ter")

      bleurt = t2t.benchmarks.find_or_create_by(name: "bleurt")
      bleurt.metrics.find_or_create_by(name: "bleurt")

      metrics = t2t.benchmarks.flat_map(&:metrics)

      100.times do |i|
        model = t2t.models.create(name: "Model #{i + 1}")
        metrics.each do |metric|
          model.scores.create(metric:, value: Random.rand(100))
        end
      end
    end
  end
end
