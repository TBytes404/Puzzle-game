defmodule PuzzleGame.Cli do
  alias PuzzleGame.Game.Engine

  def start do
    IO.puts("\nWelcome to the Locked Chamber")
    IO.puts("Solve the puzzles to escape!")

    state = Engine.new(:entrance)
    play(state)
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
