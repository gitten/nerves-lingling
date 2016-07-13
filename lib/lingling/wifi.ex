defmodule Lingling.Wifi do

  @wifi_cred Application.get_env :lingling, :cred
  

  def setup do
    Nerves.InterimWiFi.setup "wlan0", @wifi_cred
    # :timer.apply_after 5000, __MODULE__, set_sys_time, []
  end

  #ensure correct system time ssl certs
  def set_sys_time do
    status = System.cmd "ntpd", ["-q", "-p", "pool.ntp.org"]
      case status do
        {_, 0} -> :ok
        {_, 1} -> set_sys_time
      end
  end

end
