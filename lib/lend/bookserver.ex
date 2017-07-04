defmodule Lend.BookServer do
  use GenServer
  
  ## Client API

  @doc """
  Starts the book server
  """
  def start_link do
    GenServer.start_link(__MODULE__,:ok,[])
  end

  @doc """
  Fetches the current book
  """
  def fetch(server) do
    GenServer.call(server, :fetch)
  end

  ## GenServer callbacks

  def init(:ok) do
    {:ok,%Lend.Book{}}
  end

  def handle_call(:fetch,_from,book) do
    {:reply,book,book}
  end
end
