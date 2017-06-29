defmodule LendTest do
  use ExUnit.Case
  import Lend

  test "empty book" do
    assert %Lend.Book{} == %Lend.Book{borrow: [],lend: []}
  end

  test "add borrow to empty book" do
    assert add(%Lend.Book{},%Lend.Order{side: :borrow, size: 10000, rate: 0.05}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}],lend: []}
  end
  test "add lend to empty book" do
    assert add(%Lend.Book{},%Lend.Order{side: :lend,size: 10000,rate: 0.05}) ==
      %Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05}],borrow: []}
  end
end
