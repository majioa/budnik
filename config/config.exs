use Mix.Config

config :nadia,
   token: {:system, "TELEGRAM_APP_TOKEN"},
   recv_timeout: 10

config :logger, :console,
   level: :info,
   format: "$date $time [$level] $metadata$message\n",
   metadata: [:user_id]
