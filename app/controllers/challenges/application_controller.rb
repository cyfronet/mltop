module Challenges
  class ApplicationController < ApplicationController
    def policy_scope(scope, **args)
      super([ :challenges, scope ], **args)
    end

    def authorize(record, **args)
      super([ :challenges, record ], **args)
    end

    def permitted_attributes(record, **args)
      super([ :challenges, record ], **args)
    end
  end
end
