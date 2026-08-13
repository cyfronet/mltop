module ScoresHelper
  def score_color(score)
    return "rgba(0,0,0, 0)" unless score&.value

    opacity = score.normalized.clamp(0.0, 1.0)
    "rgba(188,11,175, #{opacity.round(3)})"
  end

  def score_cell(score)
    content_tag(:td, class: "score-cell dark:text-white", style: "background-color: #{score_color(score)};") do
      number_with_precision(score&.effective_value, precision: 3) || "N/A"
    end
  end
end
