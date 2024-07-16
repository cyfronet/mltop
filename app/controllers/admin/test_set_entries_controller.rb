class Admin::TestSetEntriesController < Admin::ApplicationController
  before_action :find_test_set_entry, only: %i[destroy]
  def destroy
    @test_set= @test_set_entry.test_set
    if @test_set_entry.destroy
      redirect_to admin_test_set_path(@test_set), notice: "Test set entry was successfully removed."
    end
  end
  private
  def find_test_set_entry
    @test_set_entry = TestSetEntry.find(params[:id])
  end
end
