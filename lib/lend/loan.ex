defmodule Lend.Loan do
  defstruct [:rate, :size, :lender, :borrower, :term]

  def new(
        %Lend.Order{side: :borrow, rate: borrow_rate} = borrow,
        %Lend.Order{side: :lend, rate: lend_rate} = lend,
        term
      )
      when borrow_rate >= lend_rate do
    %Lend.Loan{
      rate: (borrow.rate + lend.rate) / 2,
      size: min(borrow.leaves, lend.leaves),
      lender: lend.party,
      borrower: borrow.party,
      term: term
    }
  end
end
