defmodule PuzzleGame.Session.Upload do
  alias PuzzleGame.Session
  alias PuzzleGame.Storage

  @behaviour Session

  @type t :: %__MODULE__{capacity: integer(), buffer: binary()}
  defstruct capacity: 0, buffer: <<>>

  @impl true
  def init(size), do: {%__MODULE__{capacity: size}, nil}

  @impl true
  def handle(upload, data) do
    space = upload.capacity - String.length(upload.buffer)

    if space > String.length(data) do
      {{:continue, %{upload | buffer: upload.buffer <> data}}, nil}
    else
      data = String.slice(data, 0..space)
      id = Storage.save(upload.buffer <> data)
      {:done, "\nStory saved as #{id}\n"}
    end
  end

  @impl true
  def stop(upload),
    do: Storage.save(upload.buffer)
end
