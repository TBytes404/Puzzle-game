defmodule PuzzleGame.Session.Upload do
  alias PuzzleGame.Session
  alias PuzzleGame.Storage

  @behaviour Session

  @type t :: %__MODULE__{buffer: binary()}
  defstruct [:buffer]

  @impl true
  def init() do
    {%__MODULE__{buffer: <<>>}, nil}
  end

  @impl true
  def handle(upload, data) do
    {{:continue, %{upload | buffer: upload.buffer <> data}}, nil}
  end

  @impl true
  def stop(upload) do
    Storage.save(upload.buffer)
    |> IO.inspect()
  end
end
