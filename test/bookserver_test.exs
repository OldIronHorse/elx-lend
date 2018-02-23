defmodule BookServerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, book_server} = Lend.BookServer.start_link(18)
    {:ok, book_server: book_server}
  end

  test "initial book is empty", %{book_server: book_server} do
    assert %Lend.Book{lend: [], borrow: [], term: 18} == Lend.BookServer.fetch(book_server)
  end

  test "add: borrow order", %{book_server: book_server} do
    borrow_order = %Lend.Order{side: :borrow, size: 10000, rate: 0.05, party: "Pete"}
    Lend.BookServer.add(book_server, borrow_order)
    lend_order = %Lend.Order{side: :lend, size: 11000, rate: 0.06, party: "Bill"}
    Lend.BookServer.add(book_server, lend_order)

    assert %Lend.Book{borrow: [borrow_order], lend: [lend_order], term: 18} ==
             Lend.BookServer.fetch(book_server)
  end

  test "cross: multiple borrows", %{book_server: book_server} do
    orders = [
      Lend.Order.new(:borrow, 10000, 0.04, "Pete"),
      Lend.Order.new(:borrow, 11000, 0.04, "Bob"),
      Lend.Order.new(:lend, 15000, 0.04, "Rich"),
      Lend.Order.new(:lend, 9000, 0.05, "Dave")
    ]

    Enum.each(orders, &Lend.BookServer.add(book_server, &1))

    assert Lend.BookServer.cross(book_server) ==
             [
               %Lend.Loan{rate: 0.04, size: 10000, lender: "Rich", borrower: "Pete", term: 18},
               %Lend.Loan{rate: 0.04, size: 5000, lender: "Rich", borrower: "Bob", term: 18}
             ]

    assert %{
             borrow: [%{side: :borrow, size: 11000, leaves: 6000, rate: 0.04, party: "Bob"}],
             lend: [%{side: :lend, size: 9000, leaves: 9000, rate: 0.05, party: "Dave"}]
           } = Lend.BookServer.fetch(book_server)
  end

  test "add: missing params", %{book_server: book_server} do
    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{size: 10000, rate: 0.05, party: "Bob"})
           )

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{side: :lend, rate: 0.05, party: "Bob"})
           )

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{side: :lend, size: 10000, party: "Bob"})
           )

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{side: :lend, size: 10000, rate: 0.05})
           )

    assert catch_error(Lend.BookServer.add(book_server, %Lend.Order{}))

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{
               side: :lend,
               size: -10000,
               rate: 0.05,
               party: "Bob"
             })
           )

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{
               side: :lend,
               size: 10000,
               rate: -0.05,
               party: "Bob"
             })
           )

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{
               side: :lend,
               size: "10000",
               rate: 0.05,
               party: "Bob"
             })
           )

    assert catch_error(
             Lend.BookServer.add(book_server, %Lend.Order{
               side: :lend,
               size: 10000,
               rate: "0.05",
               party: "Bob"
             })
           )
  end
end
