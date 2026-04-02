defmodule PuzzleGame.Session.Menu do
  alias PuzzleGame.Session
  alias PuzzleGame.Session.Game
  alias PuzzleGame.Session.Upload

  @behaviour Session

  @impl true
  def init() do
    header = """
    \nWelcome to Puzzle Game!\n
    Type `play` to start the game.
    Type `upload` to upload new puzzles.\n
    """

    {nil, header}
  end

  @impl true
  def handle(_, input) do
    input
    |> String.trim()
    |> String.upcase()
    |> case do
      "EXIT" ->
        {:stop, nil}

      "PLAY" ->
        {{:switch, Game}, nil}

      "UPLOAD" ->
        {{:switch, Upload}, nil}

      _ ->
        {{:continue, nil}, "Unknown command!\n"}
    end
  end

  @impl true
  def stop(_), do: nil
end
