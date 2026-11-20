# @note Carrier calls wait on HTTP for up to `FetchRates::DEADLINE`, so allow enough threads that slow rate
#   calls leave room for cheap queries such as `matchingLanes` and `serve`.
max_threads_count = ENV.fetch('HANAMI_MAX_THREADS', 16)
min_threads_count = ENV.fetch('HANAMI_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

if ENV['PUMA_SOCKET']
  bind "unix://#{ENV.fetch('PUMA_SOCKET')}"
else
  port ENV.fetch('HANAMI_PORT', 2300)
end

environment ENV.fetch('HANAMI_ENV', 'development')
workers     ENV.fetch('HANAMI_WEB_CONCURRENCY', 2)

before_worker_boot { Hanami.shutdown }

preload_app!
