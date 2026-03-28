defmodule PuzzleGame.Story do
  @moduledoc "Provides puzzle access and navigation"

  alias PuzzleGame.Meta
  alias PuzzleGame.Puzzle

  defstruct [:meta, :puzzles]

  def meta(%__MODULE__{meta: meta}), do: meta

  def entry_puzzle(%__MODULE__{meta: %Meta{entry: entry}} = story),
    do: next_puzzle(story, %Puzzle{next: entry})

  @doc "Returns next puzzle if exists else nil"
  def next_puzzle(%__MODULE__{puzzles: puzzles}, %Puzzle{next: next}),
    do: if(next, do: Map.get(puzzles, next))
end
