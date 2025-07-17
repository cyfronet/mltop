module ScoresHelper
  def score_color(score)
    return "rgb(156, 163, 175)" unless score&.value

    red = [ 220, 38, 38 ] # red-600
    yellow = [ 251, 191, 36 ] # yellow-400
    green = [ 4, 120, 87 ] # green-700

    if score.normalized <= 0.5
      ratio = score.normalized / 0.5
      r = (red[0] + ratio * (yellow[0] - red[0])).to_i
      g = (red[1] + ratio * (yellow[1] - red[1])).to_i
      b = (red[2] + ratio * (yellow[2] - red[2])).to_i
    else
      ratio = (score.normalized - 0.5) / 0.5
      r = (yellow[0] + ratio * (green[0] - yellow[0])).to_i
      g = (yellow[1] + ratio * (green[1] - yellow[1])).to_i
      b = (yellow[2] + ratio * (green[2] - yellow[2])).to_i
    end

    "rgb(#{r}, #{g}, #{b})"
  end

  def score_cell(score)
    content_tag(:td, score.value, class: "score-cell", style: "background-color: #{score_color(score)};") do
      number_with_precision(score.value, precision: 3) || "N/A"
    end
  end
end
