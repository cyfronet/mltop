module Challenges
  module Dashboard
    class ApplicationController < ApplicationController
      def policy_scope(scope, **args)
        super([ :challenges, :dashboard, scope ], **args)
      end

      def authorize(record, query = nil)
        super([ :challenges, :dashboard, record ], query)
      end
    end
  end
end
