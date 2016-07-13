defmodule Lingling.DoorFsm do
  use Fsm, initial_state: :init



  # fsm functions
 
  defstate init do
    defevent check_door(:opened) do
      next_state(:opened)
    end
    defevent check_door(:closed) do
      next_state(:closed)
    end
  end
  

  defstate opened do
    defevent wait_for(:closed) do
    end
    defevent door_closed do
      next_state(:closed)
    end
  end


  defstate closed do
    defevent wait_for(:opened) do
    end
    defevent door_opened do
      next_state(:opened)
    end
  end



  # def fsm(state) do
  #   case state do
  #     %{state: :init} ->
  #       state
  #       |> check_door(door_status)
  #       |> fsm

  #     %{state: :opened} ->
  #       state
  #       |> wait_for(door_event)
  #       |> door_closed
  #       |> fsm

  #     %{state: :closed} ->
  #       state
  #       |> wait_for(door_event)
  #       |> door_opened
  #       |> fsm
  #   end
  # end

end
