defmodule PuzzleGame.Story do
  @moduledoc "Provides puzzle access logic"

  alias PuzzleGame.Story.Meta
  alias PuzzleGame.Story.Puzzle

  @type t :: %__MODULE__{meta: Meta, puzzles: %Puzzle{}}
  defstruct [:meta, :puzzles]

  def entry_puzzle(%__MODULE__{meta: meta, puzzles: puzzles}),
    do: puzzles[meta.entry]

  @spec next_puzzle(t(), Puzzle, binary()) :: {Puzzle | nil, binary()}
  def next_puzzle(%__MODULE__{puzzles: puzzles}, puzzle, answer) do
    case Puzzle.check_answer(puzzle, answer) do
      {:pass, puzzle} ->
        {puzzles[puzzle.next], puzzle.pass}

      {:hint, puzzle} ->
        {puzzle, puzzle.hint}

      {:fail, _} ->
        {nil, "Better luck next time!"}
    end
  end
end
