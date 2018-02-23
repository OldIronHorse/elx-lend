defmodule Lend.Order do
  defstruct [:side, :size, :leaves, :rate, :party]

  def new(side, size, rate, party) do
    %Lend.Order{
      side: side,
      size: size,
      leaves: size,
      rate: rate,
      party: party
    }
  end
end
