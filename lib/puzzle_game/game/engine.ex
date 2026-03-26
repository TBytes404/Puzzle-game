defmodule PuzzleGame.Game.Engine do
  alias PuzzleGame.Puzzle

  defstruct current: nil, tries: 0

  def new(current, tries \\ 3) do
    %__MODULE__{current: current |> Puzzle.exists(), tries: tries |> abs()}
  end

  def quest(%__MODULE__{current: cur}) do
    Puzzle.get(cur)[:quest]
  end

  def answer(%__MODULE__{tries: n, current: cur} = state, input) do
    puz = Puzzle.get(cur)

    if puz[:answer] == input,
      do: {puz[:pass], %__MODULE__{state | current: puz[:next] |> Puzzle.exists()}},
      else: {puz[:hint], %__MODULE__{tries: n - 1, current: if(n > 1, do: cur)}}
  end
end
