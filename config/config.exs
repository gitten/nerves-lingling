# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :nerves_leds, names: [ green: "led1", red: "led0" ]

import_config "slack.exs"

config :nerves_interim_wifi, regulatory_domain: "US"
import_config "wifi.exs"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"
