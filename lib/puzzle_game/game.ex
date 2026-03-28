defmodule PuzzleGame.Game do
  @moduledoc "Game state machine - pure logic, no IO"

  alias PuzzleGame.Puzzle
  alias PuzzleGame.Story

  defstruct [:story, :puzzle]

  def new(%Story{} = story) do
    %__MODULE__{
      story: story,
      puzzle: Story.entry_puzzle(story)
    }
  end

  @doc "Process answer, returns {game or nil, message}"
  def answer(%__MODULE__{puzzle: puzzle} = game, input) do
    case Puzzle.check_answer(puzzle, input) do
      {:pass, puzzle} ->
        next_puzzle = Story.next_puzzle(game.story, puzzle)
        {if(next_puzzle, do: %{game | puzzle: next_puzzle}), puzzle.pass}

      {:hint, puzzle} ->
        {%{game | puzzle: puzzle}, puzzle.hint}

      {:fail, _} ->
        {nil, "Better luck next time!"}
    end
  end
end
