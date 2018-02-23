defmodule Lend.BookServer do
  use GenServer
  require Logger

  ## Client API

  @doc """
  Starts the book server
  """
  def start_link(name) do
    GenServer.start_link(__MODULE__, %Lend.Book{}, name: name)
  end

  @doc """
  Fetches the current book
  """
  def fetch(server) do
    GenServer.call(server, :fetch)
  end

  @doc """
  Adds an order to the order book
  """
  def add(server, %Lend.Order{side: side, size: size, rate: rate, party: party} = order)
      when side in [:lend, :borrow] and is_number(size) and size > 0 and is_number(rate) and
             rate > 0 and not is_nil(party) do
    GenServer.cast(server, {:add, order})
  end

  @doc """
  Crosses all matching orders
  """
  def cross(server) do
    GenServer.call(server, :cross)
  end

  ## GenServer callbacks

  def init(book) do
    {:ok, book}
  end

  def handle_call(:fetch, _from, book) do
    {:reply, book, book}
  end

  def handle_call(:cross, _from, book) do
    {new_book, loans} = Lend.Book.cross(book)
    {:reply, loans, new_book}
  end

  def handle_cast({:add, order}, book) do
    Logger.info("Adding order #{inspect(order)}")
    {:noreply, Lend.Book.add(book, order)}
  end
end
