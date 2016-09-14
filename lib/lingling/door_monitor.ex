defmodule Lingling.DoorMonitor do
  use GenServer
  
  alias Nerves.Leds
  alias Lingling.DoorSwitch
  alias Lingling.DoorFsm

  
  def start_link do
    {:ok, pid} = return =
      GenServer.start_link(__MODULE__, [], name: :door_monitor)

    :ok = GenServer.cast pid, :fsm_start

    return
  end


  def init(_opts) do
    {:ok, _} = DoorSwitch.start_link
    door_status = DoorSwitch.status |> show_status
    
    state =
      DoorFsm.new
      |> DoorFsm.check_door(door_status)

    {:ok, state}
  end



  def show_status(status = :opened) do
    Leds.set red: :slowblink
    status
  end
  def show_status(status = :closed) do
    Leds.set red: false
    status
  end

  
  

  # state machine and door monitor call backs

  def handle_call(:door_status, caller, door) do
    {:reply, door.state, door}
  end
  
  
  def handle_cast(:fsm_start, door) do
       send self, :fsm
       {:noreply, door}
  end
  

  def handle_info(:fsm, door) do
    new_state =
      DoorSwitch.status
      |> show_status
    
    new_door = cond do
      new_state == door.state ->
        door

      true ->
        send :slack_bot, {:door_status, new_state}
        Map.put(door, :state, new_state)
    end

    :timer.sleep 2000

    send self, :fsm
    {:noreply, new_door}
  end


  
  def handle_info(_, state), do: {:noreply, state}
  
end
