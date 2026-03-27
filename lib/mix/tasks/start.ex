defmodule Mix.Tasks.Start do
  alias PuzzleGame.Game
  alias PuzzleGame.Provider

  use Mix.Task

  @impl true
  def run([]), do: run(["stories/locked-chambers.yml"])

  def run([f | _]) do
    provider = Provider.new(f)
    Game.start(provider)
  end
end
