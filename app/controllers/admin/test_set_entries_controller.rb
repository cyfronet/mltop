class Admin::TestSetEntriesController < Admin::ApplicationController
  before_action :find_test_set_entry, only: %i[destroy]
  before_action :find_test_set, only: %i[new index create]

  def new
    @test_set_entry = TestSetEntry.new
  end

  def index
    @test_set_entries = @test_set.entries
  end

  def create
    @test_set_entry = @test_set.entries.new(test_set_entry_params)
    if @test_set_entry.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @test_set= @test_set_entry.test_set
    if @test_set_entry.destroy
      redirect_to admin_test_set_path(@test_set), notice: "Test set entry was successfully removed."
    else
      redirect_to admin_test_set_path(@test_set), alert: "Unable to delete test set entry."
    end
  end

  private
    def find_test_set_entry
      @test_set_entry = TestSetEntry.find(params[:id])
    end

    def find_test_set
      @test_set = TestSet.find(params[:test_set_id])
    end

    def test_set_entry_params
      params.required(:test_set_entry).permit(:language, :input)
    end
end
