defmodule BookServerTest do
  use ExUnit.Case, async: true 
  
  setup do
    {:ok,book_server} = Lend.BookServer.start_link
    {:ok,book_server: book_server}
  end

  test "initial book is empty", %{book_server: book_server} do
    assert Lend.BookServer.fetch(book_server) == %Lend.Book{borrow: [],lend: []}
  end

  test "add: borrow order", %{book_server: book_server} do
    borrow_order = %Lend.Order{side: :borrow,size: 10000,rate: 0.05,party: "Pete"}
    Lend.BookServer.add(book_server,borrow_order)
    assert Lend.BookServer.fetch(book_server) == %Lend.Book{borrow: [borrow_order],lend: []}
    lend_order = %Lend.Order{side: :lend,size: 11000,rate: 0.06,party: "Bill"}
    Lend.BookServer.add(book_server,lend_order)
    assert Lend.BookServer.fetch(book_server) == %Lend.Book{borrow: [borrow_order],lend: [lend_order]}
  end
end
