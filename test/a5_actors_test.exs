defmodule A5ActorsTest do
  use ExUnit.Case
  doctest A5Actors

  test "greets the world" do
    assert A5Actors.hello() == :world
  end
end
