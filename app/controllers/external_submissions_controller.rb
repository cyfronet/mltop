class ExternalSubmissionsController < ApplicationController
  meetween_members_only

  def index
    @models = policy_scope(Model).external.with_not_evaluated_hypothesis
  end
end
