defmodule BookServerTest do
  use ExUnit.Case, async: true 
  
  setup do
    {:ok,book_server} = Lend.BookServer.start_link
    {:ok,book_server: book_server}
  end

  test "initial book is empty", %{book_server: book_server} do
    assert Lend.BookServer.fetch(book_server) == %Lend.Book{borrow: [],lend: []}
  end
end
