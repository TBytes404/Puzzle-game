defmodule PuzzleGame.Provider do
  def new(path) do
    path
    |> YamlElixir.read_from_file!()
    |> atomize()
  end

  def meta(puzzles), do: PuzzleGame.Meta |> struct(puzzles.__meta__)

  def exists(puzzles, label),
    do: with_key(label, &if(Map.has_key?(puzzles, &1), do: label))

  def get(puzzles, label),
    do: with_key(label, &(PuzzleGame.Puzzle |> struct(puzzles[&1])))

  defp atomize(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {String.to_atom(k), atomize(v)}
    end)
  end

  defp atomize(val), do: val

  defp with_key(label, fun) do
    label
    |> String.to_existing_atom()
    |> fun.()
  rescue
    ArgumentError -> nil
  end
end
