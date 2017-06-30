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

  test "add of a borrow order to top of book" do
    assert add(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]},
               %Lend.Order{side: :borrow,size: 10000,rate: 0.06}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.06},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.05}],
                 lend: []}
  end

  test "add of a borrow order to bottom of book" do
    assert add(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]},
               %Lend.Order{side: :borrow,size: 10000,rate: 0.04}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.04}],
                 lend: []}
  end

  test "add of a borrow order into middle of book" do
    assert add(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05},
                                   %Lend.Order{side: :borrow,size: 10000,rate: 0.03}]},
               %Lend.Order{side: :borrow,size: 10000,rate: 0.04}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.03}],
                 lend: []}
  end

  test "add borrow orders respecting time priority" do
    assert %Lend.Book{} 
    |> add %Lend.Order{side: :borrow,size: 10000,rate: 0.04}
    |> add %Lend.Order{side: :borrow,size: 10003,rate: 0.04}
    |> add %Lend.Order{side: :borrow,size: 10001,rate: 0.04}
    |> add %Lend.Order{side: :borrow,size: 10002,rate: 0.04}
    |> add %Lend.Order{side: :borrow,size: 10004,rate: 0.05} ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10004,rate: 0.05},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10003,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10001,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10002,rate: 0.04}]}
  end
end
