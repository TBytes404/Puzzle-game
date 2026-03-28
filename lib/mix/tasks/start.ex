defmodule Mix.Tasks.Start do
  alias PuzzleGame.Server

  use Mix.Task

  @impl true
  def run([]), do: run([4049])
  def run([port | []]), do: run([port, "stories/locked-chambers.yml"])
  def run([port | [path | _]]), do: Server.start(port, path)
end
