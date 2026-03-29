defmodule PuzzleGame.Game.Server do
  @moduledoc "Launches and maintains game sessions"

  alias PuzzleGame.Game
  alias PuzzleGame.Story.Importer

  def start(port, path) do
    {:ok, lsock} = :gen_tcp.listen(port, [:binary, reuseaddr: true])
    IO.puts("Server Listening: #{port}")

    story = Importer.load(path)
    acceptor(lsock, story)
  end

  defp acceptor(lsock, story, id \\ 1) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    IO.puts("Players Joined: #{id} ")

    pid = spawn(fn -> session(sock, story) end)
    :gen_tcp.controlling_process(sock, pid)
    acceptor(lsock, story, id + 1)
  end

  defp session(sock, story) do
    game = Game.new(story)
    :ok = :gen_tcp.send(sock, Game.header(game))

    game_loop(sock, game)
    :gen_tcp.shutdown(sock, :read_write)
  end

  def game_loop(_, nil), do: :ok

  def game_loop(sock, game) do
    :ok = :gen_tcp.send(sock, Game.quest(game))

    receive do
      {:tcp, ^sock, input} ->
        {updated_game, message} = Game.answer(game, input)
        :ok = :gen_tcp.send(sock, message <> "\n")
        game_loop(sock, updated_game)

      unknown ->
        IO.inspect(unknown)
    end
  end
end
