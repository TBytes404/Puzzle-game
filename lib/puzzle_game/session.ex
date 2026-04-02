defmodule PuzzleGame.Session do
  @callback init() :: {any(), iodata() | nil}
  @callback handle(any(), binary()) ::
              {{:continue, any() | :switch, module() | :stop}, iodata() | nil}
  @callback stop(any()) :: nil

  defstruct [:socket, :handler, :state]

  def start(sock, handler), do: init(sock, handler) |> loop

  defp init(sock, handler) do
    {state, header} = handler.init()
    if header, do: :ok = :gen_tcp.send(sock, header)
    %__MODULE__{socket: sock, handler: handler, state: state}
  end

  defp loop(%__MODULE__{socket: sock, handler: handler} = session) do
    :ok = :inet.setopts(session.socket, active: :once)

    receive do
      {:tcp, ^sock, input} ->
        case handler.handle(session.state, input) do
          {:stop, msg} ->
            if msg, do: :ok = :gen_tcp.send(sock, msg)
            handler.stop(session.state)

          {{:switch, handler}, msg} ->
            if msg, do: :ok = :gen_tcp.send(sock, msg)
            init(sock, handler) |> loop()

          {{:continue, new_state}, msg} ->
            if msg, do: :ok = :gen_tcp.send(sock, msg)
            loop(%{session | state: new_state})
        end

      {:tcp_closed, ^sock} ->
        handler.stop(session.state)

      unknown ->
        IO.inspect(unknown)
    end
  end
end
