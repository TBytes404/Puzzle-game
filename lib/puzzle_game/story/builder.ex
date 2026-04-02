defmodule PuzzleGame.Story.Builder do
  @moduledoc "parses raw maps into domain structs"

  alias PuzzleGame.Story
  alias PuzzleGame.Story.Puzzle

  @spec from_map(map()) :: Story.t()
  def from_map(map) do
    {meta, data} =
      map
      |> atomize_keys()
      |> Map.pop(:__meta__)

    %PuzzleGame.Story{
      meta: %{struct(Story.Meta, meta) | entry: meta[:entry] |> as_atom()},
      puzzles: build_puzzles(data, meta[:tries] |> as_int())
    }
  end

  defp build_puzzles(data, tries) do
    Map.new(data, fn {label, attrs} ->
      {label,
       %{struct(Puzzle, attrs) | next: attrs[:next] |> as_atom(), tries: tries, label: label}}
    end)
  end

  defp as_int(nil), do: nil

  defp as_int(val) do
    case val |> to_string() |> Integer.parse() do
      {n, _} -> n
      _ -> 1
    end
  end

  defp as_atom(nil), do: nil
  defp as_atom(key), do: to_string(key) |> String.to_atom()

  defp atomize_keys(map) when is_map(map) do
    Map.new(map, fn {k, v} ->
      {as_atom(k), atomize_keys(v)}
    end)
  end

  defp atomize_keys(val), do: val
end
