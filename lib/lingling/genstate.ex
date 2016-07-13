defmodule Lingling.Genstate do
  use GenServer
  
  alias Nerves.Leds
  alias Lingling.DoorSwitch
  alias Lingling.DoorFsm

  
  def start_link do
    {:ok, pid} = return = GenServer.start_link(__MODULE__, [], name: :door_monitor)
    :ok = GenServer.cast pid, :fsm_start
    return
  end

  
  def init(_opts) do
    # {:ok, _} = DoorSwitch.start_link
    # door_status = DoorSwitch.status |> show_status
    
    # state =
    #   DoorFsm.new
    #   |> DoorFsm.check_door(door_status)

    {:ok, %{one: :opened, two: :opened}}
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

  def handle_cast(:fsm_start, door) do
    send self, :fsm
    {:noreply, door}
  end

  def handle_call({:update, key, state}, from, door) do
    new_state = Map.put door, key, state
    {:reply, {:update, new_state},  new_state}
  end

  def handle_info(:fsm, door) do
    new_state = door.two
    
    new_door = cond do
      new_state == door.one ->
        door

      true ->
        
        Map.put(door, :one, new_state)
    end
    
    :timer.sleep 2000
    IO.inspect new_door
    send self, :fsm
    {:noreply, new_door}
  end
  
  def handle_info(_, _), do: :ok
  
end
