class Submissions::HypothesesController < ApplicationController
  def new
    @model = Model.find(params[:submission_id])
    @groundtruth = Groundtruth.find(params[:groundtruth_id])
    @hypothesis = Hypothesis.new(model: @model, groundtruth: @groundtruth)
  end

  def create
    @hypothesis = Hypothesis.new(hypothesis_params)
    @groundtruth = @hypothesis.groundtruth
    if @hypothesis.save
      flash.now[:notice] = "Hypothesis succesfully created"
    else
      @groundtruth = @hypothesis.groundtruth
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    @hypothesis = Hypothesis.find_by(model_id: params[:submission_id], groundtruth_id: params[:groundtruth_id])
    @groundtruth = @hypothesis.groundtruth
    if @hypothesis.destroy
      flash.now[:notice] = "Hypothesis succesfully deleted"
    else
      flash.now[:alert] = "Unable to delete hypothesis #{@hypothesis.groundtruth}"
    end
  end

  private
  def hypothesis_params
    params.require(:hypothesis).permit(:model_id, :groundtruth_id, :input)
  end
end
