defmodule LendLoanTest do
  use ExUnit.Case, async: true

  test "loan: exactly matching" do
    assert Lend.Loan.new(
             Lend.Order.new(:borrow, 10000, 0.05, "Pete"),
             Lend.Order.new(:lend, 10000, 0.05, "Bill"),
             60
           ) == %Lend.Loan{rate: 0.05, lender: "Bill", borrower: "Pete", size: 10000, term: 60}
  end

  test "loan: backwardation" do
    assert Lend.Loan.new(
             Lend.Order.new(:borrow, 10000, 0.06, "Pete"),
             Lend.Order.new(:lend, 10000, 0.04, "Bill"),
             120
           ) == %Lend.Loan{rate: 0.05, lender: "Bill", borrower: "Pete", size: 10000, term: 120}
  end

  test "loan: bigger borrow" do
    assert Lend.Loan.new(
             Lend.Order.new(:borrow, 11000, 0.05, "Pete"),
             Lend.Order.new(:lend, 10000, 0.05, "Bill"),
             18
           ) == %Lend.Loan{rate: 0.05, lender: "Bill", borrower: "Pete", size: 10000, term: 18}
  end

  test "loan: bigger lend" do
    assert Lend.Loan.new(
             Lend.Order.new(:borrow, 10000, 0.05, "Pete"),
             Lend.Order.new(:lend, 11000, 0.05, "Bill"),
             12
           ) == %Lend.Loan{rate: 0.05, lender: "Bill", borrower: "Pete", size: 10000, term: 12}
  end
end
