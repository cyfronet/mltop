module Challenges
  module Dashboard
    class ApplicationController < ApplicationController
      def policy_scope(scope, **args)
        super([ :challenges, :dashboard, scope ], **args)
      end

      def authorize(record, query = nil)
        super([ :challenges, :dashboard, record ], query)
      end

      def permitted_attributes(record, **args)
        super([ :challenges, :dashboard, record ], **args)
      end
    end
  end
end
