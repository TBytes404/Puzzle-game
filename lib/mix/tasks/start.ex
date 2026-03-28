defmodule Mix.Tasks.Start do
  alias PuzzleGame.Server

  use Mix.Task

  @impl true
  def run(_), do: Server.start()
end
