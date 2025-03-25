module ChallengeHelper
  def challenge_time_left
    distance_of_time_in_words(Time.current, challenge_end_time)
  end

  def challenge_starts_at
    distance_of_time_in_words(Time.current, challenge_start_time)
  end

  def challenge_dates
    "#{challenge_start_date} - #{challenge_end_date}"
  end

  def challenge_start_date
    l(challenge_start_time, format: :short)
  end

  def challenge_end_date
    l(challenge_end_time, format: :short)
  end

  private

  def challenge_end_time
    Rails.configuration.challenge_close_time
  end

  def challenge_start_time
    Rails.configuration.challenge_open_time
  end
end
