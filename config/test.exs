import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :puccinia_basic_poc, PucciniaBasicPocWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SXloFfZnnb5Ql9Jx+eVNOZbFFaH/yT7ZxgEhSTVI2d4bZZ8xGqHJuw+AcTHENLtQ",
  server: false

# In test we don't send emails.
config :puccinia_basic_poc, PucciniaBasicPoc.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
