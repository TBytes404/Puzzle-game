defmodule PuzzleGame.Provider do
  def new(path) do
    path
    |> YamlElixir.read_from_file!()
    |> atomize()
  end

  def meta(puzzles), do: PuzzleGame.Meta |> struct(puzzles.__meta__)

  def exists(_, nil), do: nil

  def exists(puzzles, label),
    do: if(Map.has_key?(puzzles, label |> String.to_existing_atom()), do: label)

  def get(_, nil), do: nil

  def get(puzzles, label),
    do: PuzzleGame.Puzzle |> struct(puzzles[label |> String.to_existing_atom()])

  defp atomize(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {String.to_atom(k), atomize(v)}
    end)
  end

  defp atomize(val), do: val
end
