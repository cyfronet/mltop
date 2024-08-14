class Submissions::HypothesesController < ApplicationController
  def create
    @model = Current.user.models.find(params[:submission_id])
    @hypothesis = @model.hypothesis.new(hypothesis_params)
    @test_set_entry = @hypothesis.test_set_entry
    if @hypothesis.save
      flash.now[:notice] = "Hypothesis succesfully created"
    else
      flash.now[:alert] = "There was an error creating hypothesis"
      redirect_back fallback_location: submission_task_path(@model, @model.tasks.first)
    end
  end

  def destroy
    @hypothesis = Hypothesis.joins(:model).where(models: { owner: Current.user }).find(params[:id])
    @submission_id = @hypothesis.model_id
    @test_set_entry = @hypothesis.test_set_entry
    if @hypothesis.destroy
      flash.now[:notice] = "Hypothesis succesfully deleted"
    else
      flash.now[:alert] = "Unable to delete hypothesis #{@hypothesis.test_set_entry}"
    end
  end

  private
  def hypothesis_params
    params.require(:hypothesis).permit(:test_set_entry_id, :input)
  end
end
