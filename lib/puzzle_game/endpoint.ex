defmodule PuzzleGame.Endpoint do
  @moduledoc "Launches and maintains game sessions"

  alias PuzzleGame.Session

  def start(port) do
    {:ok, lsock} =
      :gen_tcp.listen(port, [
        :binary,
        packet: :line,
        active: :once,
        reuseaddr: true
      ])

    IO.puts("Server Listening: #{port}")
    acceptor(lsock)
  end

  defp acceptor(lsock, id \\ 1) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    IO.puts("Players Joined: #{id} ")

    pid = spawn(fn -> Session.start(sock) end)
    :ok = :gen_tcp.controlling_process(sock, pid)
    acceptor(lsock, id + 1)
  end
end
