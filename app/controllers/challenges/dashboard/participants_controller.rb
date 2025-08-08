module Challenges
  module Dashboard
    class ParticipantsController < ApplicationController
      def index
        @participants = policy_scope(User, policy_scope_class: MemberPolicy::Scope).preload(models: :hypotheses)
      end
    end
  end
end
