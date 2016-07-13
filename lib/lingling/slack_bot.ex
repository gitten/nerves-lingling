defmodule Lingling.SlackBot do
  
  use Slack

  @door_channel "#doorbell"


  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end


  def handle_message(%{type: "message", text: text}, _slack) do
    IO.puts text
  end


  def handle_message(_,_), do: :ok



  # doorbell call backs
  
  def handle_info({:door_status, new_status}, slack) do
    IO.puts "sending new door status: #{new_status}"
    send_message "Door has been #{new_status}", @door_channel, slack
  end


  def handle_info(_, _), do: :ok

end

      


