module Challenges
  class ApplicationController < ApplicationController
    def policy_scope(scope, **args)
      super([ :challenges, scope ], **args)
    end

    def authorize(record, query = nil)
      super([ :challenges, record ], query)
    end

    def permitted_attributes(record, **args)
      super([ :challenges, record ], **args)
    end
  end
end
