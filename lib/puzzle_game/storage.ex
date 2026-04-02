defmodule PuzzleGame.Storage do
  @moduledoc "Loads and saves YAML file to and from map"

  @directory "store/"
  @extension ".yaml"

  @spec load(binary()) :: map()
  def load(id) do
    path(id)
    |> YamlElixir.read_from_file!()
  end

  @spec save(map()) :: binary()
  def save(map) do
    id = new_id()
    path(id) |> File.write!(map)
    id
  end

  def path(id), do: Path.join(@directory, id <> @extension)

  def new_id() do
    DateTime.utc_now()
    |> Calendar.strftime("%Y-%m-%d_%H-%M-%S_%f")
  end
end
