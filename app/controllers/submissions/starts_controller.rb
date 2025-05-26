class Submissions::StartsController < ApplicationController
  def show
    @hypothesis = Hypothesis
    .where(model: my_or_external_models)
    .find(params[:hypothesis_id])
    @user = Current.user
  end


  private
    def my_or_external_models
      Model.external.or(Model.where(owner: Current.user))
    end
end
