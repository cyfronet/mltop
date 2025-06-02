class TasksController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]
  helper_method :participant_of_challenge

  def index
    @tasks = policy_scope(Task)
    @stats = Statistics.new
  end

  def show
    @task = policy_scope(Task).with_published_test_sets.preload(:task_test_sets).find(params[:id])
    @task_test_sets = @task.task_test_sets
  end

  private

  def participant_of_challenge
    Membership.exists?(user: Current.user, challenge: Current.challenge)
  end
end
