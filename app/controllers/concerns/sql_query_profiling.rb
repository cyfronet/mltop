module SqlQueryProfiling
  extend ActiveSupport::Concern
  included do
    if Rails.env.development? && ActionController::Base.perform_caching

      around_action :n_plus_one_detection

      def n_plus_one_detection
        Prosopite.scan
        yield
      ensure
        Prosopite.finish
      end
    end
  end
end
