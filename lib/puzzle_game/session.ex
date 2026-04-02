defmodule PuzzleGame.Session do
  @callback init(any()) :: {any(), iodata() | nil}
  @callback handle(any(), binary()) ::
              {{:exit | :done | :continue, any() | :switch, module(), any()}, iodata() | nil}
  @callback stop(any()) :: nil

  alias PuzzleGame.Session.Menu

  defstruct [:socket, :handler, :state]

  def start(sock), do: boot(sock, Menu, nil) |> loop

  defp boot(sock, handler, opts) do
    {state, header} = handler.init(opts)
    send_message(sock, header)
    %__MODULE__{socket: sock, handler: handler, state: state}
  end

  defp loop(%__MODULE__{socket: sock, handler: handler} = session) do
    :inet.setopts(session.socket, active: :once)

    receive do
      {:tcp, ^sock, input} ->
        case handler.handle(session.state, input) do
          {:exit, msg} ->
            send_message(sock, msg)

          {:done, msg} ->
            send_message(sock, msg)
            boot(sock, Menu, nil) |> loop()

          {{:switch, handler, opts}, msg} ->
            send_message(sock, msg)
            boot(sock, handler, opts) |> loop()

          {{:continue, new_state}, msg} ->
            send_message(sock, msg)
            loop(%{session | state: new_state})
        end

      {:tcp_closed, ^sock} ->
        handler.stop(session.state)

      unknown ->
        IO.inspect(unknown)
    end
  end

  defp send_message(_, nil), do: nil

  defp send_message(sock, msg),
    do: if(msg, do: :gen_tcp.send(sock, msg))
end
