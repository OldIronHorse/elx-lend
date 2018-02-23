defmodule Lend.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Lend.BookServer, [:bookserver_3Y], id: :bs_3Y),
      worker(Lend.BookServer, [:bookserver_5Y], id: :bs_5Y),
      worker(Lend.BookServer, [:bookserver_10Y], id: :bs_10Y)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
