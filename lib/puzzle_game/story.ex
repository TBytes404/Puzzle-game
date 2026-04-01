defmodule PuzzleGame.Story do
  @moduledoc "Provides puzzle access and navigation"

  defmodule Meta do
    defstruct [:title, :author, :entry, tries: 1]
  end

  alias PuzzleGame.Puzzle

  defstruct [:meta, :puzzles]

  def entry_puzzle(%__MODULE__{meta: meta, puzzles: puzzles}),
    do: puzzles[meta.entry]

  @doc "Process answer, returns {game or nil, message}"
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
