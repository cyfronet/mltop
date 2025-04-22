# frozen_string_literal: true

module ChallengeSlug
  PATTERN = /(\d{7,})/
  FORMAT = "%07d"

  def self.decode(slug) = slug.to_i
  def self.encode(id) = FORMAT % id

  # We're using challenge id prefixes in the URL path. Rather than namespace
  # all our routes, we're "mounting" the Rails app at this URL prefix.
  #
  # The Extractor middleware yanks the prefix off PATH_INFO, moves it to
  # SCRIPT_NAME, and drops the account id in env['mltop.challenge_id'].
  #
  # Rails routes on PATH_INFO and builds URLs that respect SCRIPT_NAME,
  # so the main app is none the wiser. We look up the current challenge using
  # env['mltop.challenge_id'] instead of request.subdomains.first
  class Extractor
    PATH_INFO_MATCH = /\A(\/#{ChallengeSlug::PATTERN})/

    def initialize(app)
      @app = app
    end

    def call(env)
      request = ActionDispatch::Request.new(env)

      # $1, $2, $' == script_name, slug, path_info
      if request.path_info =~ PATH_INFO_MATCH
        request.script_name   = $1
        request.path_info     = $'.empty? ? "/" : $'

        # Stash the organization id
        env["mltop.challenge_id"] = ChallengeSlug.decode($2)
      end

      @app.call env
    end
  end

  # Limit session cookies to the slug path.
  class LimitSessionToAccountSlugPath
    def initialize(app)
      @app = app
    end

    def call(env)
      env["rack.session.options"][:path] = env["SCRIPT_NAME"] if env["mltop.challenge_id"]
      @app.call env
    end
  end
end
