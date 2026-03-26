defmodule PuzzleGame.Cli do
  alias PuzzleGame.Game.Engine
  alias PuzzleGame.Puzzle.Provider

  def start(path \\ "stories/locked-chambers.yml") do
    puzzles = Provider.new(path)
    meta = puzzles |> Provider.meta()
    IO.puts("\n" <> meta.title <> "\t\tby " <> meta.author)

    puzzles
    |> Engine.new("entrance", meta.tries)
    |> play()
  end

  def play(%{current: nil}), do: :ok

  def play(state) do
    IO.puts("")

    Engine.quest(state)
    |> IO.puts()

    answer =
      IO.gets("> ")
      |> String.trim()
      |> String.downcase()

    {reply, state} = Engine.answer(state, answer)
    IO.puts(reply)

    play(state)
  end
end
