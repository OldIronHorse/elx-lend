defmodule BookServerTest do
  use ExUnit.Case, async: true 
  
  setup do
    {:ok,book_server} = Lend.BookServer.start_link(Lend.BookServer)
    {:ok,book_server: book_server}
  end

  test "initial book is empty", %{book_server: book_server} do
    assert Lend.BookServer.fetch(book_server) == Lend.Book.new() 
  end

  test "add: borrow order", %{book_server: book_server} do
    borrow_order = %Lend.Order{side: :borrow,size: 10000,rate: 0.05,party: "Pete"}
    Lend.BookServer.add(book_server,borrow_order)
    lend_order = 
      %Lend.Order{side: :lend,size: 11000,rate: 0.06,party: "Bill"}
    Lend.BookServer.add(book_server,lend_order)
    assert %Lend.Book{borrow: [borrow_order],lend: [lend_order]} ==
      Lend.BookServer.fetch(book_server)
  end

  test "cross: multiple borrows", %{book_server: book_server} do
    orders = [
      %Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"},
      %Lend.Order{side: :borrow,size: 11000,rate: 0.04,party: "Bob"},
      %Lend.Order{side: :lend,size: 15000,rate: 0.04,party: "Rich"},
      %Lend.Order{side: :lend,size: 9000,rate: 0.05,party: "Dave"}
    ]
    Enum.each(orders,&(Lend.BookServer.add(book_server,&1)))
    assert Lend.BookServer.cross(book_server) == 
      [%Lend.Loan{rate: 0.04,size: 10000,lender: "Rich",borrower: "Pete"},
       %Lend.Loan{rate: 0.04,size: 5000,lender: "Rich",borrower: "Bob"}]
    assert %{
      borrow: [%{side: :borrow,size: 6000,rate: 0.04,party: "Bob"}],
      lend: [%{side: :lend,size: 9000,rate: 0.05,party: "Dave"}]
    } = Lend.BookServer.fetch(book_server)
  end

  test "add: missing params", %{book_server: book_server} do
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{size: 10000,rate: 0.05,party: "Bob"}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,rate: 0.05,party: "Bob"}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,size: 10000,party: "Bob"}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,size: 10000,rate: 0.05}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,size: -10000,rate: 0.05,party: "Bob"}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,size: 10000,rate: -0.05,party: "Bob"}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,size: "10000",rate: 0.05,party: "Bob"}))
    assert catch_error(Lend.BookServer.add(book_server,%Lend.Order{side: :lend,size: 10000,rate: "0.05",party: "Bob"}))
  end
end
