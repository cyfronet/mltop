module Challenges
  module Dashboard
    class AllowedGroupsController < ApplicationController
      before_action :set_and_authorize_allowed_group, only: %i[ edit update destroy ]

      def new
        @allowed_group = Current.challenge.allowed_groups.build
        authorize(@allowed_group)
      end

      def create
        @allowed_group = Current.challenge.allowed_groups.build(permitted_attributes(AllowedGroup))
        authorize(@allowed_group)
        if @allowed_group.save
          Memberships::UpdateRoles.new(challenge: Current.challenge).call
          flash.now[:notice] = "Evaluator allowed_group was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @allowed_group.update(permitted_attributes(@allowed_group))
          Memberships::UpdateRoles.new(challenge: Current.challenge).call
          redirect_to edit_dashboard_challenge_path(Current.challenge),
          notice: "Allowed group was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @allowed_group.destroy
          Memberships::UpdateRoles.new(challenge: Current.challenge).call
          redirect_to edit_dashboard_challenge_path(Current.challenge),
          notice:  "\"#{@allowed_group.group_name}\" allowed group was sucessfully deleted."
        else
          redirect_to edit_dashboard_challenge_path(Current.challenge),
          alert: "Unable to delete \"#{@allowed_group.group_name}\" allowed group."
        end
      end

      private

        def set_and_authorize_allowed_group
          @allowed_group = AllowedGroup.find(params[:id])
          authorize(@allowed_group)
        end
    end
  end
end
