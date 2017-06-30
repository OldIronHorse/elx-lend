defmodule Lend do
  @moduledoc """
  Documentation for Lend.
  """
  
  defmodule Book do
    defstruct borrow: [], lend: []
  end

  defmodule Order do
    defstruct [:side,:size,:rate]
  end

  def add(book,%Order{side: :borrow} = order) do
    %{book | borrow: insert(book.borrow, order)}
  end
  def add(book,%Order{side: :lend} = order) do
    %{book | lend: insert(book.lend,order)}
  end

  def insert(orders,order) do
    insert(Enum.reverse(orders),order,[])
  end
  def insert([o|os],%Order{side: :borrow} = order, orders) do
    if order.rate > o.rate do
      insert(os,order,[o|orders])
    else
      Enum.reverse([o|os])++[order|orders]
    end
  end
  def insert([o|os],%Order{side: :lend} = order, orders) do
    if order.rate < o.rate do
      insert(os,order,[o|orders])
    else
      Enum.reverse([o|os])++[order|orders]
    end
  end
  def insert([],order,orders) do
    [order|orders]
  end
end
