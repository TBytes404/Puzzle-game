defmodule PuzzleGame.Session do
  alias PuzzleGame.Story
  alias PuzzleGame.Game

  def start(path, send, recv) do
    story = Story.Importer.load(path)
    game = Game.new(story)

    %{title: title, author: author} = story.meta
    send.("\n#{title}\t\tby #{author}\n")

    game_loop(game, send, recv)
  end

  defp game_loop(nil, _, _), do: :ok

  defp game_loop(game, send, recv) do
    %{quest: quest, label: label} = game.puzzle
    send.("\n#{label}> #{quest}\nanswer> ")

    recv.(fn input ->
      {updated_game, message} = Game.answer(game, input)
      send.(message <> "\n")
      game_loop(updated_game, send, recv)
    end)
  end
end
