module Top
  ScoreWithNormalization = Struct.new(:score, :normalized) do
    delegate_missing_to :score
  end
end

