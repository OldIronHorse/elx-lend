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

  #TODO break out loan() function to create a loan from 2 orders
  def cross(book) do
    cross(book,[])
  end
  def cross(%Book{borrow: [%Order{rate: borrow_rate}=b|bs],
                  lend: [%Order{rate: lend_rate}=l|ls]}=book,loans) when lend_rate < borrow_rate do
    rate = (b.rate+l.rate)/2
    cond do
      b.size == l.size ->
        cross(%{book | borrow: bs,lend: ls},[%Loan{borrower: b.party, lender: l.party, rate: rate, size: b.size}|loans])
      b.size < l.size ->
        cross(%{book | borrow: bs,lend: [%{l | size: l.size-b.size}|ls]},
             [%Loan{borrower: b.party, lender: l.party, rate: rate, size: b.size}|loans])
      b.size > l.size ->
        cross(%{book | borrow: [%{b | size: b.size-l.size}|bs],lend: ls},
              [%Loan{borrower: b.party, lender: l.party, rate: rate, size: l.size}|loans])
    end
  end
  def cross(%Book{borrow: [%Order{size: size, rate: rate}=b|bs],lend: [%Order{size: size, rate: rate}=l|ls]},loans) do
    cross(%Book{borrow: bs, lend: ls},
          [%Loan{borrower: b.party, lender: l.party, rate: rate, size: size}|loans])
  end
  def cross(%Book{borrow: [%Order{size: borrow_size, rate: rate}=b|bs],
                  lend: [%Order{size: lend_size, rate: rate}=l|ls]},loans) when borrow_size > lend_size do
    cross(%Book{borrow: [%{b | size: borrow_size-lend_size}|bs],lend: ls},
          [%Loan{borrower: b.party, lender: l.party, rate: rate, size: lend_size}|loans])
  end
  def cross(%Book{borrow: [%Order{size: borrow_size, rate: rate}=b|bs],
                  lend: [%Order{size: lend_size, rate: rate}=l|ls]},loans) when borrow_size < lend_size do
    cross(%Book{borrow: bs,lend: [%{l | size: lend_size-borrow_size}|ls]},
          [%Loan{borrower: b.party, lender: l.party, rate: rate, size: borrow_size}|loans])
  end
  def cross(book,loans) do
    {book,Enum.reverse(loans)}
  end
end
