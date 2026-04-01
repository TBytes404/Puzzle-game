defmodule PuzzleGame.Upload.Server do
  @moduledoc "Launches and maintains game sessions"

  alias PuzzleGame.Upload

  def start(port) do
    {:ok, lsock} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    IO.puts("Server Listening: #{port}")
    acceptor(lsock)
  end

  defp acceptor(lsock, id \\ 1) do
    {:ok, sock} = :gen_tcp.accept(lsock)
    IO.puts("Players Joined: #{id} ")

    pid = spawn(fn -> session(sock) end)
    :gen_tcp.controlling_process(sock, pid)
    acceptor(lsock, id + 1)
  end

  defp session(sock) do
    :inet.setopts(sock, active: true)
    upload = Upload.new()
    upload_loop(sock, upload)
    :gen_tcp.shutdown(sock, :read_write)
  end

  def upload_loop(_, nil), do: :ok

  def upload_loop(sock, upload) do
    receive do
      {:tcp, ^sock, input} ->
        updated_upload = Upload.handle(upload, input)
        upload_loop(sock, updated_upload)

      {:tcp_closed, ^sock} ->
        Upload.finish(upload)

      unknown ->
        IO.inspect(unknown)
    end
  end
end
