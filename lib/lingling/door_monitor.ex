defmodule Lingling.DoorMonitor do
  use Fsm, initial_state: :init

  alias Nerves.Leds

  @door_pin 7
  def start(_,_) do
  #   Gpio.start_link(@door_pin, :output, name: :door)
  #   Gpio.set_int(:door, :both)
  #   spawn fn -> fsm(new)
  end

  def fsm(state) do
    case state do
      %{state: :init} ->
        state
        |> check_door(door_status)
        |> fsm

      %{state: :opened} ->
        state
        |> wait_for(door_event)
        |> door_closed
        |> fsm

      %{state: :closed} ->
        state
        |> wait_for(door_event)
        |> door_opened
        |> fsm
    end
  end


  defp door_status do
    case Gpio.read(:door) do
      1 ->
        :opened
        
      0 ->
        :closed
    end
  end


  defp door_event do
    #   receive do
    #   {:gpio_interupt, @door_pin, :rising} ->
    #     :opened

    #   {:gpio_interupt, @door_pin, :falling} ->
    #     :closed

    #   _ ->
    #     IO.puts :stderr, "Unexpected message received"
    #     door_event
    # end
  end

  
  defp broadcast(:opened) do
    Leds.set green: :fastblink
  end
  defp broadcast(:closed) do
    Leds.set green: false
  end
    

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
      broadcast :closed
    end
    defevent door_closed do
      next_state(:closed)
    end
  end


  defstate closed do
    defevent wait_for(:opened) do
      broadcast :opened
    end
    defevent door_opened do
      next_state(:opened)
    end
  end

end
