defmodule PuzzleGame.Story.Importer do
  @moduledoc "Loads and parses YAML story files into domain structs"

  @stories_dir "stories/"

  alias PuzzleGame.Puzzle
  alias PuzzleGame.Story.Meta

  @spec load(binary()) :: Story.t()
  def load(id) do
    {meta, data} =
      path(id)
      |> YamlElixir.read_from_file!()
      |> atomize_keys()
      |> Map.pop(:__meta__)

    %PuzzleGame.Story{
      meta: %{struct(Meta, meta) | entry: meta[:entry] |> as_atom()},
      puzzles: build_puzzles(data, meta[:tries] |> as_int())
    }
  end

  # @spec save(Story.t()) :: binary()
  def save(story) do
    new_id()
    |> IO.inspect()
    |> File.write!(story)
  end

  def path(id), do: Path.join(@stories_dir, id <> ".yaml")

  def new_id() do
    DateTime.now!("Etc/UTC")
    |> to_string()
    |> String.replace(":", "-")
    |> String.replace(".", "_")
    |> String.replace(" ", "_")
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
