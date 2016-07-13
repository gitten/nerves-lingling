defmodule Lingling.Mixfile do
  use Mix.Project

  @target System.get_env("NERVES_TARGET") || "rpi"

  def project do
    [app: :lingling,
     version: "0.0.1",
     target: @target,
     archives: [nerves_bootstrap: "0.1.3"],
     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Lingling, []},
     applications: [:nerves,
                    :logger,
                    :nerves_leds,
                    :httpoison,
                    :nerves_interim_wifi,
                    :fsm, :elixir_ale,
                    :slack,
                    :websocket_client
                   ]]
  end

  def deps do
    [{:nerves, "~> 0.3.2"},
     {:nerves_leds, "~> 0.7.0"},
     {:nerves_interim_wifi, "~> 0.0.2"},
     {:fsm, "~> 0.2.0"},
     {:elixir_ale, "~> 0.5.5"},
     {:slack, "~> 0.7.0"},
     {:websocket_client, git: "https://github.com/jeremyong/websocket_client"},
     {:httpoison, "~> 0.8.0"}
    ]
  end

  def system(target) do
    [{:"nerves_system_#{target}", ">= 0.0.0"}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
