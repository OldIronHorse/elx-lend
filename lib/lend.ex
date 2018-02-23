defmodule Lend do
  use Application
  require Logger

  def start(type, args) do
    Logger.info("type=#{Kernel.inspect(type)}, args=#{Kernel.inspect(args)}")
    Lend.Supervisor.start_link()
  end
end
