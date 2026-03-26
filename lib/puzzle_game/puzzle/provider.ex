defmodule PuzzleGame.Puzzle.Provider do
  def new(path) do
    path
    |> YamlElixir.read_from_file!()
  end

  def meta(puzzles),
    do: puzzles["__meta__"] |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

  def get(puzzles, label), do: puzzles[label]

  def exists(puzzles, label),
    do: if(Map.has_key?(puzzles, label), do: label)
end
