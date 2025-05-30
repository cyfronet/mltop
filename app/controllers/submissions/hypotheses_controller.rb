class Submissions::HypothesesController < ApplicationController
  def create
    @model = Current.user.models.find(params[:submission_id])
    @hypothesis = @model.hypothesis.new(hypothesis_params)
    authorize(@hypothesis)

    if @hypothesis.save
      flash.now[:notice] = "Hypothesis succesfully created"
    else
      flash.now[:alert] = "Unable to create hypothesis"
      render(:create, status: :bad_request)
    end
  end

  def destroy
    @hypothesis = Hypothesis.owned_by(Current.user).find(params[:id])
    authorize(@hypothesis)

    if @hypothesis.destroy
      @empty_hypothesis = Hypothesis::Empty.new(@hypothesis.model, @hypothesis.test_set_entry)
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
