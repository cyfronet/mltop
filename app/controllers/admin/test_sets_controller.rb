class Admin::TestSetsController < Admin::ApplicationController
  before_action :find_test_set, only: %i[edit update destroy show]

  def index
    @test_sets = TestSet.all
  end

  def show
  end

  def new
    @test_set = TestSet.new
    @tasks = Task.all
  end

  def create
    @test_set = TestSet.new(test_set_params)

    if @test_set.save
      redirect_to admin_test_set_path(@test_set), notice: "Test set was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @test_set.update(test_set_params)
      redirect_to admin_test_set_path(@test_set), notice: "Test set was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @test_set.destroy
      redirect_to admin_test_sets_path, notice: "Test set \"#{@test_set.name}\" was successfully deleted."
    else
      redirect_to admin_test_set_path(@test_set), alert: "Unable to delete test set."
    end
  end


  private
    def test_set_params
      params.required(:test_set).permit(:name, :description)
    end

    def find_test_set
      @test_set = TestSet.find(params[:id])
    end
end
