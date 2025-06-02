class Admin::ParticipantsController < Admin::ApplicationController
  def index
    @participants = policy_scope(User, policy_scope_class: MemberPolicy::Scope).preload(models: :hypothesis)
  end
end
