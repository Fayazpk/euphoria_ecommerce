# Set the number of threads
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Specify the port
port ENV.fetch("PORT", 3000)

# Explicitly set the binding to avoid SSL confusion
bind "tcp://0.0.0.0:#{ENV.fetch("PORT", 3000)}"

# Specify the environment
environment ENV.fetch("RAILS_ENV", "development")

# Allow puma to be restarted by `bin/rails restart` command
plugin :tmp_restart

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file if requested
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Disable SSL
ssl_bind_enabled = false