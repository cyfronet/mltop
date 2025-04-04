class Submissions::HypothesesController < ApplicationController
  def create
    @model = Current.user.models.find(params[:submission_id])
    @hypothesis = @model.hypothesis.new(hypothesis_params)

    if @hypothesis.save
      redirect_back fallback_location: model_path(@model), notice: "Hypothesis succesfully created"
    else
      redirect_back fallback_location: model_path(@model), alert: "Unable to create hypothesis"
    end
  end

  def destroy
    @hypothesis = Hypothesis.owned_by(Current.user).find(params[:id])

    if @hypothesis.destroy
      @empty_hypothesis = Hypothesis::Empty.new(@hypothesis.model, @hypothesis.test_set_entry)
      flash.now[:notice] = "Hypothesis succesfully deleted"
    else
      flash.now[:alert] = "Unable to delete hypothesis #{@hypothesis.test_set_entry}"
    end
  end

  private
  def hypothesis_params
    input = ActiveStorage::Blob.find_signed(params[:hypothesis][:input])
    params.require(:hypothesis).permit(:test_set_entry_id).merge(input:)
  end
end
