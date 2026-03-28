defmodule PuzzleGame.Server do
  alias PuzzleGame.Story
  alias PuzzleGame.Game

  def start() do
    {:ok, lsock} = :gen_tcp.listen(4049, [:binary, reuseaddr: true])
    IO.puts("Starting Server...")
    acceptor(lsock)
  end

  defp acceptor(lsock) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    IO.puts("Player Joined")
    session(sock)
    acceptor(lsock)
  end

  defp session(sock) do
    story = Story.Importer.load("stories/locked-chambers.yml")
    game = Game.new(story)

    %{title: title, author: author} = story.meta
    :ok = :gen_tcp.send(sock, "\n#{title}\t\tby #{author}\n")

    game_loop(game, sock)
    :ok = :gen_tcp.shutdown(sock, :read_write)
  end

  defp game_loop(game, sock) do
    if not Game.over?(game) do
      %{quest: quest, label: label} = game.puzzle
      :ok = :gen_tcp.send(sock, "\n#{label}> #{quest}\nanswer> ")

      receive do
        {:tcp, ^sock, input} ->
          case Game.answer(game, input) do
            {:fail, message, _} ->
              :ok = :gen_tcp.send(sock, message <> "\n")

            {_, message, updated_game} ->
              :ok = :gen_tcp.send(sock, message <> "\n")
              game_loop(updated_game, sock)
          end
      end
    end
  end
end
