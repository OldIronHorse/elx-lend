defmodule LendTest do
  use ExUnit.Case, async: true
  import Lend

  test "empty book" do
    assert %{borrow: [],lend: []} = Lend.Book.new() 
  end

  test "add borrow to empty book" do
    assert %{
      borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}],
      lend: []
    } = add(
      Lend.Book.new(),
      %Lend.Order{side: :borrow, size: 10000, rate: 0.05}
    )
  end
  
  test "add lend to empty book" do
    assert %{
      lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05}],
      borrow: []
    } = add(
      Lend.Book.new(),
      %Lend.Order{side: :lend,size: 10000,rate: 0.05}
    )
  end

  test "add a borrow order to top of book" do
    assert %Lend.Book{
      borrow: [
        %Lend.Order{side: :borrow,size: 10000,rate: 0.06},
        %Lend.Order{side: :borrow,size: 10000,rate: 0.05}
      ],
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.05})
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.06})
  end

  test "add a lend order to top of book" do
    assert %{
      lend: [
        %Lend.Order{side: :lend,size: 10000,rate: 0.05},
        %Lend.Order{side: :lend,size: 10000,rate: 0.06}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.06})
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.05})
  end

  test "add of a borrow order to bottom of book" do
    assert %{
      borrow: [
        %Lend.Order{side: :borrow,size: 10000,rate: 0.05},
        %Lend.Order{side: :borrow,size: 10000,rate: 0.04}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.05})
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04})
  end

  test "add of a lend order to bottom of book" do
    assert %{
      lend: [
        %Lend.Order{side: :lend,size: 10000,rate: 0.05},
        %Lend.Order{side: :lend,size: 10000,rate: 0.06}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.05})
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.06})
  end

  test "add of a borrow order into middle of book" do
    assert %{
      borrow: [
        %Lend.Order{side: :borrow,size: 10000,rate: 0.05},
        %Lend.Order{side: :borrow,size: 10000,rate: 0.04},
        %Lend.Order{side: :borrow,size: 10000,rate: 0.03}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.05})
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.03})
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04})
  end

  test "add of a lend order into middle of book" do
    assert %Lend.Book{
      lend: [
        %Lend.Order{side: :lend,size: 10000,rate: 0.03},
        %Lend.Order{side: :lend,size: 10000,rate: 0.04},
        %Lend.Order{side: :lend,size: 10000,rate: 0.05}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.03})
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.05})
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.04})
  end

  test "add borrow orders respecting time priority" do
    assert %{
      borrow: [
        %Lend.Order{side: :borrow,size: 10004,rate: 0.05},
        %Lend.Order{side: :borrow,size: 10000,rate: 0.04},
        %Lend.Order{side: :borrow,size: 10003,rate: 0.04},
        %Lend.Order{side: :borrow,size: 10001,rate: 0.04},
        %Lend.Order{side: :borrow,size: 10002,rate: 0.04}
      ]
    } = Lend.Book.new() 
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10003,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10001,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10002,rate: 0.04})
    |> add(%Lend.Order{side: :borrow,size: 10004,rate: 0.05}) 
  end

  test "add lend orders respecting time priority" do
    assert %{
      lend: [
        %Lend.Order{side: :lend,size: 10004,rate: 0.03},
        %Lend.Order{side: :lend,size: 10000,rate: 0.04},
        %Lend.Order{side: :lend,size: 10003,rate: 0.04},
        %Lend.Order{side: :lend,size: 10001,rate: 0.04},
        %Lend.Order{side: :lend,size: 10002,rate: 0.04}
      ]
    } = Lend.Book.new() 
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10003,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10001,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10002,rate: 0.04})
    |> add(%Lend.Order{side: :lend,size: 10004,rate: 0.03})
  end

  test "cross: empty book" do
    assert cross(Lend.Book.new()) == {Lend.Book.new(),[]}
  end

  test "cross: no lenders" do
    assert {
      %{borrow: [%Lend.Order{side: :borrow,size: 10000,rate: 0.05}]},
      []
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.05})
    |> cross
  end

  test "cross: no borrowers" do
    assert {
      %{lend: [%Lend.Order{side: :lend,size: 10000,rate: 0.05}]},
      []
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.05})
    |> cross
  end

  test "cross: exact match" do
    assert {
      %{
        borrow: [%Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
        lend: [%Lend.Order{side: :lend,size: 9000,rate: 0.05}]
      },
      [ %Lend.Loan{rate: 0.04,size: 10000,lender: "Rich",borrower: "Pete"}]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"})
    |> add(%Lend.Order{side: :borrow,size: 11000,rate: 0.03})
    |> add(%Lend.Order{side: :lend,size: 10000,rate: 0.04,party: "Rich"})
    |> add(%Lend.Order{side: :lend,size: 9000,rate: 0.05})
    |> cross
  end

  test "cross: partial borrow" do
    assert {
      %{
        borrow: [
          %Lend.Order{side: :borrow,size: 4000,rate: 0.04,party: "Pete"},
          %Lend.Order{side: :borrow,size: 11000,rate: 0.03}
        ],
        lend: [
          %Lend.Order{side: :lend,size: 9000,rate: 0.05}
        ]
      },
      [%Lend.Loan{rate: 0.04,size: 6000,lender: "Rich",borrower: "Pete"}]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"})
    |> add(%Lend.Order{side: :borrow,size: 11000,rate: 0.03})
    |> add(%Lend.Order{side: :lend,size: 6000,rate: 0.04,party: "Rich"})
    |> add(%Lend.Order{side: :lend,size: 9000,rate: 0.05}) 
    |> cross
  end

  test "cross: partial lend" do
    assert {
      %{
        borrow: [%Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
        lend: [
          %Lend.Order{side: :lend,size: 50000,rate: 0.04,party: "Rich"},
          %Lend.Order{side: :lend,size: 9000,rate: 0.05}
        ]
      },
      [%Lend.Loan{rate: 0.04,size: 10000,lender: "Rich",borrower: "Pete"}]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"})
    |> add(%Lend.Order{side: :borrow,size: 11000,rate: 0.03})
    |> add(%Lend.Order{side: :lend,size: 60000,rate: 0.04,party: "Rich"})
    |> add(%Lend.Order{side: :lend,size: 9000,rate: 0.05}) 
    |> cross
  end

  test "cross: multiple borrows" do
    assert {
      %{
        borrow: [
          %Lend.Order{side: :borrow,size: 6000,rate: 0.04,party: "Bob"}
        ],
        lend: [%Lend.Order{side: :lend,size: 9000,rate: 0.05}]
      },
      [
        %Lend.Loan{rate: 0.04,size: 10000,lender: "Rich",borrower: "Pete"},
        %Lend.Loan{rate: 0.04,size: 5000,lender: "Rich",borrower: "Bob"}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.04,party: "Pete"})
    |> add(%Lend.Order{side: :borrow,size: 11000,rate: 0.04,party: "Bob"})
    |> add(%Lend.Order{side: :lend,size: 15000,rate: 0.04,party: "Rich"})
    |> add(%Lend.Order{side: :lend,size: 9000,rate: 0.05}) 
    |> cross
  end

  test "cross: backwardation" do
    assert {
      %{
        borrow: [%Lend.Order{side: :borrow,size: 11000,rate: 0.03}],
        lend: [%Lend.Order{side: :lend,size: 5000,rate: 0.05,party: "Bob"}]
      },
      [
        %Lend.Loan{rate: 0.045,size: 6000,lender: "Rich",borrower: "Pete"},
        %Lend.Loan{rate: 0.05,size: 4000,lender: "Bob",borrower: "Pete"}
      ]
    } = Lend.Book.new()
    |> add(%Lend.Order{side: :borrow,size: 10000,rate: 0.05,party: "Pete"})
    |> add(%Lend.Order{side: :borrow,size: 11000,rate: 0.03})
    |> add(%Lend.Order{side: :lend,size: 6000,rate: 0.04,party: "Rich"})
    |> add(%Lend.Order{side: :lend,size: 9000,rate: 0.05,party: "Bob"})
    |> cross
  end

  test "loan: exactly matching" do
    assert loan(%Lend.Order{side: :borrow,size: 10000,rate: 0.05,party: "Pete"},
                %Lend.Order{side: :lend,size: 10000,rate: 0.05,party: "Bill"}) ==
      %Lend.Loan{rate: 0.05,lender: "Bill",borrower: "Pete",size: 10000}
  end

  test "loan: backwardation" do
    assert loan(%Lend.Order{side: :borrow,size: 10000,rate: 0.06,party: "Pete"},
                %Lend.Order{side: :lend,size: 10000,rate: 0.04,party: "Bill"}) ==
      %Lend.Loan{rate: 0.05,lender: "Bill",borrower: "Pete",size: 10000}
  end

  test "loan: bigger borrow" do
    assert loan(%Lend.Order{side: :borrow,size: 11000,rate: 0.05,party: "Pete"},
                %Lend.Order{side: :lend,size: 10000,rate: 0.05,party: "Bill"}) ==
      %Lend.Loan{rate: 0.05,lender: "Bill",borrower: "Pete",size: 10000}
  end

  test "loan: bigger lend" do
    assert loan(%Lend.Order{side: :borrow,size: 10000,rate: 0.05,party: "Pete"},
                %Lend.Order{side: :lend,size: 11000,rate: 0.05,party: "Bill"}) ==
      %Lend.Loan{rate: 0.05,lender: "Bill",borrower: "Pete",size: 10000}
  end
end
