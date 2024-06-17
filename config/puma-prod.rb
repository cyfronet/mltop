max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

environment ENV.fetch("RAILS_ENV") { "production" }

app_path = ENV.fetch("APP_PATH")

pidfile ENV.fetch("PIDFILE") { "tmp/server.pid" }
state_path ENV.fetch("PIDFILE") { "tmp/server.state" }
bind "unix://#{app_path}/tmp/server.socket"

workers_count = Integer(ENV.fetch("WEB_CONCURRENCY", 1))
workers workers_count if workers_count > 1

preload_app!
