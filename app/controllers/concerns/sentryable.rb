# frozen_string_literal: true

module Sentryable
  extend ActiveSupport::Concern

  included do
    before_action :set_sentry_context, if: :sentry_enabled?
  end

  private
    def set_sentry_context
      if user = Current.user
        Sentry.set_user(id: user.id, email: user.email)
      end
    end

    def sentry_enabled?
      Rails.env.production?
    end
end
