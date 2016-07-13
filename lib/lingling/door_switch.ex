defmodule Lingling.DoorSwitch do

  @door_pin 7


  def start_link do
    Gpio.start_link(@door_pin, :input, name: :door)
  end


  def status do
    case Gpio.read(:door) do
      1 ->
        :opened
        
      0 ->
        :closed
    end
  end

end
