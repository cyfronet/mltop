module Challenges
  module Dashboard
    class TestSetsController < ApplicationController
      before_action :find_and_authorize_test_set, only: %i[edit update destroy show]

      def index
        @test_sets = policy_scope(TestSet).includes(:challenge)
      end

      def show
      end

      def new
        @test_set = TestSet.new
        authorize(@test_set)
      end

      def create
        @test_set = Current.challenge.test_sets.build(test_set_params)

        if @test_set.save
          redirect_to dashboard_test_set_path(@test_set),
            notice: "Test set was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @test_set.update(test_set_params)
          redirect_to dashboard_test_set_path(@test_set),
            notice: "Test set was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @test_set.destroy
          redirect_to dashboard_test_sets_path,
            notice: "Test set \"#{@test_set.name}\" was successfully deleted."
        else
          redirect_to dashboard_test_set_path(@test_set),
            alert: "Unable to delete test set."
        end
      end

      private
        def test_set_params
          params.expect(test_set: [
            :name, :description, :published, task_test_sets_attributes: [ [ :description, :id ] ]
          ])
        end

        def find_and_authorize_test_set
          @test_set = policy_scope(TestSet).preload(entries: { groundtruth_attachment: :blob, input_attachment: :blob }).find(params[:id])
          authorize(@test_set)
        end
    end
  end
end
