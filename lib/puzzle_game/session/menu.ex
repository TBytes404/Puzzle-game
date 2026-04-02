defmodule PuzzleGame.Session.Menu do
  alias PuzzleGame.Storage
  alias PuzzleGame.Protocol
  alias PuzzleGame.Session
  alias PuzzleGame.Session.Game
  alias PuzzleGame.Session.Upload

  @behaviour Session

  @impl true
  def init(_) do
    header =
      "\nWelcome to Puzzle Game!\n\n" <>
        (Protocol.usage()
         |> Enum.map(fn {cmd, desc} ->
           "Type `#{cmd}` to #{desc}.\n"
         end)
         |> Enum.join()) <> "\n"

    {nil, header}
  end

  @impl true
  def handle(_, input) do
    case Protocol.parse(input) do
      :exit -> {:exit, nil}
      :list -> {:done, (Storage.list() |> Enum.join("\n")) <> "\n"}
      {:play, id} -> {{:switch, Game, id}, nil}
      {:upload, size} -> {{:switch, Upload, size}, nil}
      _ -> {{:continue, nil}, "\nUnknown command!\n"}
    end
  end

  @impl true
  def stop(_), do: nil
end
