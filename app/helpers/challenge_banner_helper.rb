module ChallengeBannerHelper
  def challenge_open?
    Time.current.between?(Current.challenge.starts_at, Current.challenge.ends_at)
  end

  def challenge_finished?
    Time.current.after?(Current.challenge.ends_at)
  end

  def challenge_status_border_class
    challenge_open? ? "text-green-900" : "text-yellow-900"
  end

  def challenge_status_banner_border
    challenge_open? ? "border-green-400 bg-green-100" : "border-yellow-400 bg-yellow-300"
  end

  def challenge_status_banner_text
    if challenge_open?
      "The challenge is open. Time left:  #{challenge_time_left} (#{challenge_end_date})"
    elsif challenge_finished?
      "The challenge is closed. You can browse the results, but you cannot make new submissions."
    else
      "The challenge has not yet started. It will start in #{challenge_starts_at}"
    end
  end

  def challenge_start_date
    l(Current.challenge.starts_at, format: :short)
  end

  def challenge_end_date
    l(Current.challenge.ends_at, format: :short)
  end

  def challenge_time_left
    distance_of_time_in_words(Time.current, Current.challenge.ends_at)
  end

  def challenge_starts_at
    distance_of_time_in_words(Time.current, Current.challenge.starts_at)
  end
end
