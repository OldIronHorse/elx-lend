defmodule Lend.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__,:ok)
  end

  def init(:ok) do
    children = [worker(Lend.BookServer,[Lend.BookServer])]
    supervise(children,strategy: :one_for_one)
  end
end
