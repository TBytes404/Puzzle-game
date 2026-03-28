defmodule Mix.Tasks.Start do
  alias PuzzleGame.Cli

  use Mix.Task

  @impl true
  def run([]), do: run(["stories/locked-chambers.yml"])
  def run([path | _]), do: Cli.run(path)
end
