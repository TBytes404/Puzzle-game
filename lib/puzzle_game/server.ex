defmodule PuzzleGame.Server do
  alias PuzzleGame.Session

  def start(port, path) do
    {:ok, lsock} = :gen_tcp.listen(port, [:binary, reuseaddr: true])
    IO.puts("Server Listening: #{port}")

    acceptor(lsock, path)
  end

  defp acceptor(lsock, path, id \\ 1) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    IO.puts("Players Joined: #{id} ")

    pid = spawn(fn -> session(sock, path) end)
    :gen_tcp.controlling_process(sock, pid)
    acceptor(lsock, id + 1)
  end

  defp session(sock, path) do
    Session.start(
      path,
      &(:ok = :gen_tcp.send(sock, &1)),
      fn fun ->
        receive do
          {:tcp, ^sock, input} ->
            fun.(input)

          unknown ->
            IO.inspect(unknown)
        end
      end
    )

    :gen_tcp.shutdown(sock, :read_write)
  end
end
