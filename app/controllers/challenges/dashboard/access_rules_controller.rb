module Challenges
  module Dashboard
    class AccessRulesController < ApplicationController
      before_action :set_and_authorize_access_rule, only: %i[ edit update destroy ]

      def new
        @access_rule = Current.challenge.access_rules.build
        authorize(@access_rule)
      end

      def create
        @access_rule = Current.challenge.access_rules.build(permitted_attributes(AccessRule))
        authorize(@access_rule)
        if @access_rule.save
          flash.now[:notice] = "Evaluator access_rule was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @access_rule.update(permitted_attributes(@access_rule))
          redirect_to edit_dashboard_challenge_path(Current.challenge),
          notice: "Access rule was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @access_rule.destroy
          redirect_to edit_dashboard_challenge_path(Current.challenge),
          notice:  "\"#{@access_rule.group_name}\" access rule was sucessfully deleted."
        else
          redirect_to edit_dashboard_challenge_path(Current.challenge),
          alert: "Unable to delete \"#{@access_rule.group_name}\" access rule."
        end
      end

      private

      def set_and_authorize_access_rule
        @access_rule = AccessRule.find(params[:id])
        authorize(@access_rule)
      end
    end
  end
end
