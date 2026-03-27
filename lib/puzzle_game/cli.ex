defmodule PuzzleGame.Cli do
  alias PuzzleGame.Game
  alias PuzzleGame.Provider

  def start(path) do
    puzzles = Provider.new(path)
    meta = puzzles |> Provider.meta()
    IO.puts("\n" <> meta.title <> "\t\tby " <> meta.author)

    puzzles
    |> Game.new(meta.entry, meta.tries)
    |> play()
  end

  defp play(%{current: nil}), do: :ok

  defp play(state) do
    IO.puts("")

    Game.quest(state)
    |> IO.puts()

    answer =
      IO.gets("> ")
      |> String.trim()
      |> String.downcase()

    {reply, state} = Game.answer(state, answer)
    IO.puts(reply)

    play(state)
  end
end
