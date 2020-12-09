defmodule BudnikTest do
  use ExUnit.Case
  doctest Budnik

  test "greets the world" do
    assert Budnik.hello() == :world
  end
end
