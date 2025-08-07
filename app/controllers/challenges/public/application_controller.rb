module Challenges
  module Public
    class ApplicationController < ApplicationController
      allow_unauthenticated_access

      def policy_scope(scope, **args)
        super([ :challenges, :public, scope ], **args)
      end

      def authorize(record, query, **args)
        super([ :challenges, :public, record ], query, **args)
      end

      def permitted_attributes(record, **args)
        super([ :challenges, :public, record ], **args)
      end
    end
  end
end
