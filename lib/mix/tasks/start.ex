defmodule Mix.Tasks.Start do
  alias PuzzleGame.Upload.Server

  use Mix.Task

  @impl true
  def run([]), do: run(["4049"])
  def run([port | []]), do: run([port, "locked-chambers"])
  def run([port | [path | _]]), do: Server.start(String.to_integer(port), path)
end
