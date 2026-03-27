defmodule Mix.Tasks.Start do
  alias PuzzleGame.Cli
  use Mix.Task

  @impl true
  def run([]), do: Cli.start("stories/locked-chambers.yml")
  def run([f | _]), do: Cli.start(f)
end
