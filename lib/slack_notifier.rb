class SlackNotifier
  WEBHOOK_URL = Rails.application.credentials.dig(:slack, :new_submission_webhook)
  NOTIFIABLE_CHALLENGE_IDS = [ 5 ]

  def self.send_new_submission_notification(model)
    return unless Rails.env.production?
    return unless NOTIFIABLE_CHALLENGE_IDS.include?(model.challenge_id)

    post(
      text: "📬 New challenge submission",
      attachments: [
        {
          color: "good",
          fields: [
            { title: "Model",     value: model.name,                  short: true },
            { title: "Owner",     value: model.owner.email,           short: true }
          ]
        }
      ]
    )
  rescue => e
    Rails.logger.error("[SlackNotifier] Failed to send notification for model #{model.id}: #{e.message}")
  end

  def self.post(payload)
    uri = URI.parse(WEBHOOK_URL)
    response = Net::HTTP.post(uri, payload.to_json, "Content-Type" => "application/json")

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error("[SlackNotifier] Unexpected response: #{response.code} #{response.body}")
    end
  end

  private_class_method :post
end
