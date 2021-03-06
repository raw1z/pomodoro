# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :pomodoro, Pomodoro.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Y96BrWl57OVCi3aUMNqxBMiGzJJ3+js4X6VLvoTCx4w6bRHcax9j3F0Qih/sA/uR",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Pomodoro.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :pomodoro, ecto_repos: [Pomodoro.Repo]

