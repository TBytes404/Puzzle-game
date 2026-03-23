defmodule PuzzleGame.Game.Engine do
  alias PuzzleGame.Game.Puzzle

  defstruct current: nil, failed: 0

  def new(current) do
    %__MODULE__{current: Puzzle.exists(current)}
  end

  def quest(%__MODULE__{current: cur}) do
    Puzzle.get(cur)[:quest]
  end

  defp next(%__MODULE__{failed: n, current: cur}, nil),
    do: %__MODULE__{failed: n + 1, current: if(n < 2, do: cur, else: nil)}

  defp next(_, nxt),
    do: %__MODULE__{current: Puzzle.exists(nxt)}

  def(answer(%__MODULE__{current: cur} = state, input)) do
    with puz <- Puzzle.get(cur) do
      if puz[:answer] == input,
        do: {puz[:pass], next(state, puz[:next])},
        else: {puz[:hint], next(state, nil)}
    end
  end
end
