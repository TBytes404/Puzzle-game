defmodule PuzzleGame.Cli do
  @moduledoc "Handles all user interaction"

  alias PuzzleGame.Game
  alias PuzzleGame.Story

  def run(story_path) do
    story = Story.Importer.load(story_path)
    game = Game.new(story)

    meta = Story.meta(story)
    IO.puts("\n#{meta.title}\t\tby #{meta.author}")
    game_loop(game)
  end

  defp game_loop(game) do
    IO.puts("")

    if not Game.over?(game) do
      IO.puts(game.puzzle.quest)
      input = IO.gets("> ")

      case Game.answer(game, input) do
        {:fail, message, _} ->
          IO.puts(message)

        {_, message, updated_game} ->
          IO.puts(message)
          game_loop(updated_game)
      end
    end
  end
end
