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

  @doc "Process answer, returns {:pass or :hint or :fail, message, game}"
  def answer(%__MODULE__{puzzle: puzzle} = game, input) do
    if Puzzle.correct?(puzzle, input) do
      next_puzzle = Story.next_puzzle(game.story, puzzle)
      {:pass, puzzle.pass, %{game | puzzle: next_puzzle}}
    else
      case Puzzle.decrement_tries(puzzle) do
        nil -> {:fail, puzzle.hint, game}
        new_puzzle -> {:hint, puzzle.hint, %{game | puzzle: new_puzzle}}
      end
    end
  end

  def over?(%__MODULE__{puzzle: nil}), do: true
  def over?(%__MODULE__{}), do: false
end
