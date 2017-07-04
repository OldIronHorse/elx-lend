defmodule Lend.BookServer do
  use GenServer
  
  ## Client API

  @doc """
  Starts the book server
  """
  def start_link do
    GenServer.start_link(__MODULE__,%Lend.Book{},[])
  end

  @doc """
  Fetches the current book
  """
  def fetch(server) do
    GenServer.call(server,:fetch)
  end

  @doc """
  Adds an order to the order book
  """
  def add(server,order) do
    GenServer.cast(server,{:add,order})
  end

  @doc """
  Crosses all matching orders
  """
  def cross(server) do
    GenServer.call(server,:cross)
  end

  ## GenServer callbacks

  def init(book) do
    {:ok,book}
  end

  def handle_call(:fetch,_from,book) do
    {:reply,book,book}
  end
  def handle_call(:cross,_from,book) do
    {new_book,loans} = Lend.cross(book)
    {:reply,loans,new_book}
  end

  def handle_cast({:add,order},book) do
    {:noreply,Lend.add(book,order)}
  end
end
