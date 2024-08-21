class Submissions::TasksController < ApplicationController
  helper_method :entries_for_test_set

  def index
    model = Current.user.models.find(params[:submission_id])
    redirect_to submission_task_path(model, model.tasks.first)
  end

  def show
    @model = Current.user.models.find(params[:submission_id])
    @task = @model.tasks.find(params[:id])
    @entries_with_hypotheses = Hypothesis.get_with_evaluations_by_entry_and_model(model: @model, entries: @task.test_set_entries)
  end

  private
    def entries_for_test_set(task)
      @entries ||= @task.test_set_entries.group_by(&:test_set_id)
      @entries[task.id]
    end
end
