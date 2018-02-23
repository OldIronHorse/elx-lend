defmodule Lend do
  @moduledoc """
  Documentation for Lend.
  """

  def add(book, %Lend.Order{side: :borrow} = order) do
    %{book | borrow: insert(book.borrow, order)}
  end

  def add(book, %Lend.Order{side: :lend} = order) do
    %{book | lend: insert(book.lend, order)}
  end

  def insert(orders, order) do
    insert(Enum.reverse(orders), order, [])
  end

  def insert([o | os], %Lend.Order{side: :borrow} = order, orders) do
    if order.rate > o.rate do
      insert(os, order, [o | orders])
    else
      Enum.reverse([o | os]) ++ [order | orders]
    end
  end

  def insert([o | os], %Lend.Order{side: :lend} = order, orders) do
    if order.rate < o.rate do
      insert(os, order, [o | orders])
    else
      Enum.reverse([o | os]) ++ [order | orders]
    end
  end

  def insert([], order, orders) do
    [order | orders]
  end

  def cross(book) do
    cross(book, [])
  end

  def cross(
        %Lend.Book{
          borrow: [%Lend.Order{rate: borrow_rate} = b | bs],
          lend: [%Lend.Order{rate: lend_rate} = l | ls]
        } = book,
        loans
      )
      when lend_rate <= borrow_rate do
    new_loan = Lend.Loan.new(b, l)

    cond do
      b.leaves == l.leaves ->
        cross(%{book | borrow: bs, lend: ls}, [new_loan | loans])

      b.leaves < l.leaves ->
        cross(
          %{
            book
            | borrow: bs,
              lend: [%{l | leaves: l.leaves - new_loan.size} | ls]
          },
          [new_loan | loans]
        )

      b.leaves > l.leaves ->
        cross(
          %{
            book
            | borrow: [%{b | leaves: b.leaves - new_loan.size} | bs],
              lend: ls
          },
          [new_loan | loans]
        )
    end
  end

  def cross(book, loans) do
    {book, Enum.reverse(loans)}
  end
end
