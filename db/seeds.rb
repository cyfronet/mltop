ModelType.find_or_create_by(name: "Text to text", from: :text, to: :text)
ModelType.find_or_create_by(name: "Text to movie", from: :text, to: :movie)
ModelType.find_or_create_by(name: "Movie to movie", from: :movie, to: :movie)
ModelType.find_or_create_by(name: "Movie to text", from: :movie, to: :text)
