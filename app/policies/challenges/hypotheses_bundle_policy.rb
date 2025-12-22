module Challenges
  class HypothesesBundlePolicy < ApplicationPolicy
    def create?
      owner? && challenge_open? && no_processsing_bundle?
    end

    def permitted_attributes
      [ :archive ]
    end

    private

      def owner?
        record.model.owner == user
      end

      def no_processsing_bundle?
        !record.model.hypotheses_bundles.where(state: "processing").exists?
      end
  end
end
