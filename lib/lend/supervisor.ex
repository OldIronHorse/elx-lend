defmodule Lend.Supervisor do
  use Supervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    books = Application.get_env(:lend, :books)
    Logger.info("books=#{Kernel.inspect(books)}")

    children = 
      for book <- books do
        worker(Lend.BookServer, [book], id: book)
      end

    supervise(children, strategy: :one_for_one)
  end
end
