defmodule Lend.Book do
  defstruct borrow: [], lend: []

  def new() do
    %Lend.Book{}
  end
end
