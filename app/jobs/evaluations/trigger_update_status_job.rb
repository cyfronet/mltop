# frozen_string_literal: true

module Evaluations
  class TriggerUpdateStatusJob < ApplicationJob
    def perform
      hosts = Site.pluck(:host)
      User.joins(:evaluations)
      .where(evaluations: { status: [ :pending, :running ] }).uniq
      .map do |user|
        hosts.map do |host|
          UpdateStatusJob.perform_later(user, host)
        end
      end
    end
  end
end
