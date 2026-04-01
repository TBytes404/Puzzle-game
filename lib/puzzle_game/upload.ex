defmodule PuzzleGame.Upload do
  alias PuzzleGame.Story.Importer

  @type t :: %__MODULE__{buffer: binary()}
  defstruct [:buffer]

  def new() do
    %__MODULE__{buffer: <<>>}
  end

  @spec handle(t(), binary()) :: t()
  def handle(upload, input) do
    update_in(upload.buffer, &(&1 <> input))
  end

  def finish(upload) do
    Importer.save(upload.buffer)
  end
end
