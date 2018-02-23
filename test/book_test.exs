defmodule LendBookTest do
  use ExUnit.Case, async: true

  test "empty book" do
    assert %{borrow: [], lend: []} = Lend.Book.new()
  end

  test "add borrow to empty book" do
    assert %{
             borrow: [%Lend.Order{side: :borrow, size: 10000, rate: 0.05}],
             lend: []
           } = Lend.Book.add(Lend.Book.new(), %Lend.Order{side: :borrow, size: 10000, rate: 0.05})
  end

  test "add lend to empty book" do
    assert %{
             lend: [%Lend.Order{side: :lend, size: 10000, rate: 0.05}],
             borrow: []
           } = Lend.Book.add(Lend.Book.new(), %Lend.Order{side: :lend, size: 10000, rate: 0.05})
  end

  test "add a borrow order to top of book" do
    assert %Lend.Book{
             borrow: [
               %Lend.Order{side: :borrow, size: 10000, rate: 0.06},
               %Lend.Order{side: :borrow, size: 10000, rate: 0.05}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.05})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.06})
  end

  test "add a lend order to top of book" do
    assert %{
             lend: [
               %Lend.Order{side: :lend, size: 10000, rate: 0.05},
               %Lend.Order{side: :lend, size: 10000, rate: 0.06}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.06})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.05})
  end

  test "add of a borrow order to bottom of book" do
    assert %{
             borrow: [
               %Lend.Order{side: :borrow, size: 10000, rate: 0.05},
               %Lend.Order{side: :borrow, size: 10000, rate: 0.04}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.05})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.04})
  end

  test "add of a lend order to bottom of book" do
    assert %{
             lend: [
               %Lend.Order{side: :lend, size: 10000, rate: 0.05},
               %Lend.Order{side: :lend, size: 10000, rate: 0.06}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.05})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.06})
  end

  test "add of a borrow order into middle of book" do
    assert %{
             borrow: [
               %Lend.Order{side: :borrow, size: 10000, rate: 0.05},
               %Lend.Order{side: :borrow, size: 10000, rate: 0.04},
               %Lend.Order{side: :borrow, size: 10000, rate: 0.03}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.05})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.03})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.04})
  end

  test "add of a lend order into middle of book" do
    assert %Lend.Book{
             lend: [
               %Lend.Order{side: :lend, size: 10000, rate: 0.03},
               %Lend.Order{side: :lend, size: 10000, rate: 0.04},
               %Lend.Order{side: :lend, size: 10000, rate: 0.05}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.03})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.05})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.04})
  end

  test "add borrow orders respecting time priority" do
    assert %{
             borrow: [
               %Lend.Order{side: :borrow, size: 10004, rate: 0.05},
               %Lend.Order{side: :borrow, size: 10000, rate: 0.04},
               %Lend.Order{side: :borrow, size: 10003, rate: 0.04},
               %Lend.Order{side: :borrow, size: 10001, rate: 0.04},
               %Lend.Order{side: :borrow, size: 10002, rate: 0.04}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10003, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10001, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10002, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10004, rate: 0.05})
  end

  test "add lend orders respecting time priority" do
    assert %{
             lend: [
               %Lend.Order{side: :lend, size: 10004, rate: 0.03},
               %Lend.Order{side: :lend, size: 10000, rate: 0.04},
               %Lend.Order{side: :lend, size: 10003, rate: 0.04},
               %Lend.Order{side: :lend, size: 10001, rate: 0.04},
               %Lend.Order{side: :lend, size: 10002, rate: 0.04}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10003, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10001, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10002, rate: 0.04})
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10004, rate: 0.03})
  end

  test "cross: empty book" do
    assert Lend.Book.cross(Lend.Book.new()) == {Lend.Book.new(), []}
  end

  test "cross: no lenders" do
    assert {
             %{borrow: [%Lend.Order{side: :borrow, size: 10000, rate: 0.05}]},
             []
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :borrow, size: 10000, rate: 0.05})
             |> Lend.Book.cross
  end

  test "cross: no borrowers" do
    assert {
             %{lend: [%Lend.Order{side: :lend, size: 10000, rate: 0.05}]},
             []
           } =
             Lend.Book.new()
             |> Lend.Book.add(%Lend.Order{side: :lend, size: 10000, rate: 0.05})
             |> Lend.Book.cross
  end

  test "cross: exact match" do
    assert {
             %{
               borrow: [%Lend.Order{side: :borrow, size: 11000, leaves: 11000, rate: 0.03}],
               lend: [%Lend.Order{side: :lend, size: 9000, leaves: 9000, rate: 0.05}]
             },
             [%Lend.Loan{rate: 0.04, size: 10000, lender: "Rich", borrower: "Pete"}]
           } =
             Lend.Book.new()
             |> Lend.Book.add(Lend.Order.new(:borrow, 10000, 0.04, "Pete"))
             |> Lend.Book.add(Lend.Order.new(:borrow, 11000, 0.03, "Bill"))
             |> Lend.Book.add(Lend.Order.new(:lend, 10000, 0.04, "Rich"))
             |> Lend.Book.add(Lend.Order.new(:lend, 9000, 0.05, "Bob"))
             |> Lend.Book.cross
  end

  test "cross: partial borrow" do
    assert {
             %{
               borrow: [
                 %Lend.Order{side: :borrow, size: 10000, leaves: 4000, rate: 0.04, party: "Pete"},
                 %Lend.Order{side: :borrow, size: 11000, leaves: 11000, rate: 0.03, party: "Bill"}
               ],
               lend: [
                 %Lend.Order{side: :lend, size: 9000, leaves: 9000, rate: 0.05, party: "Bob"}
               ]
             },
             [%Lend.Loan{rate: 0.04, size: 6000, lender: "Rich", borrower: "Pete"}]
           } =
             Lend.Book.new()
             |> Lend.Book.add(Lend.Order.new(:borrow, 10000, 0.04, "Pete"))
             |> Lend.Book.add(Lend.Order.new(:borrow, 11000, 0.03, "Bill"))
             |> Lend.Book.add(Lend.Order.new(:lend, 6000, 0.04, "Rich"))
             |> Lend.Book.add(Lend.Order.new(:lend, 9000, 0.05, "Bob"))
             |> Lend.Book.cross
  end

  test "cross: partial lend" do
    assert {
             %{
               borrow: [
                 %Lend.Order{side: :borrow, size: 11000, leaves: 11000, rate: 0.03, party: "Bill"}
               ],
               lend: [
                 %Lend.Order{side: :lend, size: 60000, leaves: 50000, rate: 0.04, party: "Rich"},
                 %Lend.Order{side: :lend, size: 9000, leaves: 9000, rate: 0.05, party: "Bob"}
               ]
             },
             [%Lend.Loan{rate: 0.04, size: 10000, lender: "Rich", borrower: "Pete"}]
           } =
             Lend.Book.new()
             |> Lend.Book.add(Lend.Order.new(:borrow, 10000, 0.04, "Pete"))
             |> Lend.Book.add(Lend.Order.new(:borrow, 11000, 0.03, "Bill"))
             |> Lend.Book.add(Lend.Order.new(:lend, 60000, 0.04, "Rich"))
             |> Lend.Book.add(Lend.Order.new(:lend, 9000, 0.05, "Bob"))
             |> Lend.Book.cross
  end

  test "cross: multiple borrows" do
    assert {
             %Lend.Book{
               borrow: [
                 %Lend.Order{side: :borrow, size: 11000, leaves: 6000, rate: 0.04, party: "Bob"}
               ],
               lend: [
                 %Lend.Order{side: :lend, size: 9000, rate: 0.05, party: "Bill", leaves: 9000}
               ]
             },
             [
               %Lend.Loan{rate: 0.04, size: 10000, lender: "Rich", borrower: "Pete"},
               %Lend.Loan{rate: 0.04, size: 5000, lender: "Rich", borrower: "Bob"}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(Lend.Order.new(:borrow, 10000, 0.04, "Pete"))
             |> Lend.Book.add(Lend.Order.new(:borrow, 11000, 0.04, "Bob"))
             |> Lend.Book.add(Lend.Order.new(:lend, 15000, 0.04, "Rich"))
             |> Lend.Book.add(Lend.Order.new(:lend, 9000, 0.05, "Bill"))
             |> Lend.Book.cross
  end

  test "cross: backwardation" do
    assert {
             %{
               borrow: [
                 %Lend.Order{side: :borrow, size: 11000, leaves: 11000, rate: 0.03, party: "Bill"}
               ],
               lend: [
                 %Lend.Order{side: :lend, size: 9000, leaves: 5000, rate: 0.05, party: "Bob"}
               ]
             },
             [
               %Lend.Loan{rate: 0.045, size: 6000, lender: "Rich", borrower: "Pete"},
               %Lend.Loan{rate: 0.05, size: 4000, lender: "Bob", borrower: "Pete"}
             ]
           } =
             Lend.Book.new()
             |> Lend.Book.add(Lend.Order.new(:borrow, 10000, 0.05, "Pete"))
             |> Lend.Book.add(Lend.Order.new(:borrow, 11000, 0.03, "Bill"))
             |> Lend.Book.add(Lend.Order.new(:lend, 6000, 0.04, "Rich"))
             |> Lend.Book.add(Lend.Order.new(:lend, 9000, 0.05, "Bob"))
             |> Lend.Book.cross
  end
end
