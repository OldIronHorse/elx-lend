defmodule Lend.Order do
  defstruct [:side, :size, :leaves, :rate, :party]

  def new(side, size, rate, party) when side in [:lend, :borrow] and is_number(size) and is_number(rate) do
    %Lend.Order{
      side: side,
      size: size,
      leaves: size,
      rate: rate,
      party: party
    }
  end
end
