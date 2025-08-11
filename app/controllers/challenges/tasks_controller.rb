module Challenges
  class TasksController < ApplicationController
    allow_unauthenticated_access
    scoped_authorization :challenges, :public

    def index
      @tasks = policy_scope(Task)
      @stats = Statistics.new
    end

    def show
      @task = policy_scope(Task).with_published_test_sets.preload(:task_test_sets).find(params[:id])
      @task_test_sets = @task.task_test_sets
    end
  end
end
