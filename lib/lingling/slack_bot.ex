defmodule Lingling.SlackBot do
  defstruct event_time: nil
  use Slack

  @door_channel "#doorbell-test"

  def rtm_test do
    start_link(Application.get_env(:slack, :api_token_test))
  end

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end


  def handle_message(msg = %{type: "message", text: text}, slack) do
    IO.puts text
    
    bot_id = "<@#{slack.me.id}>:"
    
    case format_msg(text) do
      [^bot_id | rest] ->
        send self, {:cmd, rest, msg.channel}
        :ok

      _ ->
        :ok
    end
  end


  def handle_message(_,_), do: :ok



  # doorbell call backs
  
  def handle_info({:door_status, new_status}, slack) do
    IO.puts "sending new door status: #{new_status}"
    send_message ":door: has been #{new_status}", @door_channel, slack
    {:ok, new_status}
  end

  def handle_info({:cmd, data, channel}, slack) do
    case data do
      ["echo", text] ->
        send_message text, channel, slack

      _ -> :ok
    end
  end

  
  def handle_info(_, _), do: :ok


  defp format_msg(text) do
    String.split(text, " ", parts: 3, trim: true)
  end

end
