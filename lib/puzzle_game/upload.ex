defmodule PuzzleGame.Upload do
  alias PuzzleGame.Session
  alias PuzzleGame.Story.Store

  @behaviour Session

  @type t :: %__MODULE__{buffer: binary()}
  defstruct [:buffer]

  @impl true
  def init() do
    {%__MODULE__{buffer: <<>>}, nil}
  end

  @impl true
  def handle(upload, input) do
    {%{upload | buffer: upload.buffer <> input}, nil}
  end

  @impl true
  def finish(upload) do
    Store.save(upload.buffer)
    |> IO.inspect()
  end
end
