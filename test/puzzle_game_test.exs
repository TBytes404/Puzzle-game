defmodule PuzzleGameTest do
  use ExUnit.Case
  doctest PuzzleGame

  test "greets the world" do
    assert PuzzleGame.hello() == :world
  end
end
