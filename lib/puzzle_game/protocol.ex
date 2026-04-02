defmodule PuzzleGame.Protocol do
  def usage() do
    %{
      "LIST" => "list available stories",
      "PLAY" => "start a random story",
      "PLAY <ID>" => "start the story",
      "UPLOAD <SIZE>" => "upload new story",
      "QUIT / EXIT" => "exit application"
    }
  end

  def parse(data) do
    case split(data) do
      ["EXIT" | _] -> :exit
      ["QUIT" | _] -> :exit
      ["LIST" | _] -> :list
      ["PLAY"] -> {:play, :random}
      ["PLAY", id] -> {:play, id}
      ["UPLOAD", size] -> {:upload, String.to_integer(size)}
      _ -> :unknown
    end
  end

  defp split(data) do
    data
    |> String.trim()
    |> String.split()
    |> case do
      [] -> []
      [h | t] -> [String.upcase(h) | t]
    end
  end
end
