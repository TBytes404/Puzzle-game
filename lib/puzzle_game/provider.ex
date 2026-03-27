defmodule PuzzleGame.Provider do
  alias PuzzleGame.Meta
  alias PuzzleGame.Puzzle

  defstruct []

  def new(path) do
    path
    |> YamlElixir.read_from_file!()
    |> atomize_keys()
  end

  def meta(provider), do: struct(Meta, provider.__meta__)

  def get_puzzle(provider),
    do: get_puzzle(provider, meta(provider).entry)

  def get_puzzle(provider, label) do
    with_key(label, fn key ->
      puzzle = struct(Puzzle, provider[key])
      %{puzzle | tries: puzzle.tries || meta(provider).tries}
    end)
  end

  defp atomize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {String.to_atom(k), atomize_keys(v)}
    end)
  end

  defp atomize_keys(val), do: val

  defp with_key("__meta__", _), do: nil

  defp with_key(label, fun) do
    label
    |> String.to_existing_atom()
    |> fun.()
  rescue
    ArgumentError -> nil
  end
end
