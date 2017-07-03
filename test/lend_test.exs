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

  test "add a borrow order to top of book" do
    assert add(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]},
               %Lend.Order{side: :borrow,size: 10000,rate: 0.06}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.06},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.05}]}
  end

  test "add a lend order to top of book" do
    assert add(%Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.06}]},
               %Lend.Order{side: :lend,size: 10000,rate: 0.05}) ==
      %Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05},
                          %Lend.Order{side: :lend,size: 10000,rate: 0.06}]}
  end

  test "add of a borrow order to bottom of book" do
    assert add(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]},
               %Lend.Order{side: :borrow,size: 10000,rate: 0.04}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.04}]}
  end

  test "add of a lend order to bottom of book" do
    assert add(%Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05}]},
               %Lend.Order{side: :lend,size: 10000,rate: 0.06}) ==
      %Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05},
                          %Lend.Order{side: :lend,size: 10000,rate: 0.06}]}
  end

  test "add of a borrow order into middle of book" do
    assert add(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05},
                                   %Lend.Order{side: :borrow,size: 10000,rate: 0.03}]},
               %Lend.Order{side: :borrow,size: 10000,rate: 0.04}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.03}]}
  end

  test "add of a lend order into middle of book" do
    assert add(%Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.03},
                                   %Lend.Order{side: :lend,size: 10000,rate: 0.05}]},
               %Lend.Order{side: :lend,size: 10000,rate: 0.04}) ==
      %Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.03},
                          %Lend.Order{side: :lend,size: 10000,rate: 0.04},
                          %Lend.Order{side: :lend,size: 10000,rate: 0.05}]}
  end

  test "add borrow orders respecting time priority" do
    assert %Lend.Book{} 
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10003,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10001,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10002,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10004,rate: 0.05}) ==
      %Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10004,rate: 0.05},
                          %Lend.Order{side: :borrow,size: 10000,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10003,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10001,rate: 0.04},
                          %Lend.Order{side: :borrow,size: 10002,rate: 0.04}]}
  end

  test "add lend orders respecting time priority" do
    assert %Lend.Book{} 
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10003,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10001,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10002,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10004,rate: 0.03}) ==
      %Lend.Book{lend: [%Lend.Order{side: :lend,size: 10004,rate: 0.03},
                          %Lend.Order{side: :lend,size: 10000,rate: 0.04},
                          %Lend.Order{side: :lend,size: 10003,rate: 0.04},
                          %Lend.Order{side: :lend,size: 10001,rate: 0.04},
                          %Lend.Order{side: :lend,size: 10002,rate: 0.04}]}
  end

  test "cross: empty book" do
    assert cross(%Lend.Book{}) == {%Lend.Book{},[]}
  end

  test "cross: no lenders" do
    assert cross(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]}) ==
      {%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]},[]}
  end

  test "cross: no borrowers" do
    assert cross(%Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05}]}) ==
      {%Lend.Book{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05}]},[]}
  end

  test "cross: exact match" do
    assert cross(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"},
                                     %Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
                            lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.04,party: "Rich"},
                                   %Lend.Order{side: :lend,size: 9000,rate: 0.05}]}) ==
      {%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
                  lend: [%Lend.Order{side: :lend,size: 9000,rate: 0.05}]},
       [%Lend.Loan{rate: 0.04,size: 10000,lender: "Rich",borrower: "Pete"}]}
  end

  test "cross: partial borrow" do
    assert cross(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"},
                                     %Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
                            lend: [%Lend.Order{side: :lend,size: 6000,rate: 0.04,party: "Rich"},
                                   %Lend.Order{side: :lend,size: 9000,rate: 0.05}]}) ==
      {%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 4000,rate: 0.04,party: "Pete"},
                           %Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
                  lend: [%Lend.Order{side: :lend,size: 9000,rate: 0.05}]},
       [%Lend.Loan{rate: 0.04,size: 6000,lender: "Rich",borrower: "Pete"}]}
  end

  test "cross: partial lend" do
    assert cross(%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"},
                                     %Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
                            lend: [%Lend.Order{side: :lend,size: 60000,rate: 0.04,party: "Rich"},
                                   %Lend.Order{side: :lend,size: 9000,rate: 0.05}]}) ==
      {%Lend.Book{borrow: [%Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
                  lend: [%Lend.Order{side: :lend,size: 50000,rate: 0.04,party: "Rich"},
                         %Lend.Order{side: :lend,size: 9000,rate: 0.05}]},
       [%Lend.Loan{rate: 0.04,size: 10000,lender: "Rich",borrower: "Pete"}]}
  end
end
