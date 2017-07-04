defmodule Lend do
  @moduledoc """
  Documentation for Lend.
  """
  
  defmodule Book do
    defstruct borrow: [], lend: []
  end

  defmodule Order do
    defstruct [:side,:size,:rate,:party]
  end

  defmodule Loan do
    defstruct [:rate,:size,:lender,:borrower]
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

  def loan(%Order{side: :borrow,rate: borrow_rate}=borrow,%Order{side: :lend,rate: lend_rate}=lend) when borrow_rate >= lend_rate do
    rate = (borrow_rate+lend_rate)/2
    %Loan{rate: rate,size: min(borrow.size,lend.size),borrower: borrow.party,lender: lend.party}
  end

  def cross(book) do
    cross(book,[])
  end
  def cross(%Book{borrow: [%Order{rate: borrow_rate}=b|bs],
                  lend: [%Order{rate: lend_rate}=l|ls]}=book,loans) when lend_rate <= borrow_rate do
    new_loan = loan(b,l)
    cond do
      b.size == l.size ->
        cross(%{book | borrow: bs,lend: ls},[new_loan|loans])
      b.size < l.size ->
        cross(%{book | borrow: bs,lend: [%{l | size: l.size-new_loan.size}|ls]},[new_loan|loans])
      b.size > l.size ->
        cross(%{book | borrow: [%{b | size: b.size-new_loan.size}|bs],lend: ls},[new_loan|loans])
    end
  end
  def cross(book,loans) do
    {book,Enum.reverse(loans)}
  end
end
