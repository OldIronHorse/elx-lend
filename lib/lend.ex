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
    %{book | borrow: [order|book.borrow]}
  end
  def add(book,%Order{side: :lend} = order) do
    %{book | lend: [order|book.lend]}
  end
end
