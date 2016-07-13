defmodule Lingling do
  use Application

  @slack_token Application.get_env(:slack, :api_token)
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # some hacks
    Lingling.Wifi.setup
    :timer.sleep 3000
    Lingling.Wifi.set_sys_time

    # :timer.sleep 3000
    {:ok, bot} = Lingling.SlackBot.start_link(@slack_token)
    Process.register(bot, :slack_bot)

    Lingling.DoorMonitor.start_link

    # Define workers and child supervisors to be supervised
    children = [

      # worker(Lingling.SlackBot, [@slack_token, name: :slack_bot])

      # worker(Lingling.DoorMonitor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lingling.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
