# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# FIXME: does this need to be more secure?
secret_key_base = String.duplicate("x", 64)

# Configures the endpoint
config :fam, Fam.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: secret_key_base,
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Fam.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "Fam",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: secret_key_base,
  serializer: Fam.GuardianSerializer

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
