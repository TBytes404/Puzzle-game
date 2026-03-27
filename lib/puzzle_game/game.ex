defmodule PuzzleGame.Game do
  alias PuzzleGame.Provider

  defstruct [:current, tries: 0, puzzles: %{}]

  def new(puzzles, current, tries \\ 3) do
    %__MODULE__{
      puzzles: puzzles,
      current: puzzles |> Provider.exists(current),
      tries: tries |> abs()
    }
  end

  def quest(%__MODULE__{puzzles: p, current: cur}) do
    Provider.get(p, cur).quest
  end

  def answer(%__MODULE__{puzzles: p, current: cur, tries: n} = state, input) do
    puz = Provider.get(p, cur)

    if puz.answer |> to_string() == input,
      do: {puz.pass, %{state | current: Provider.exists(p, puz.next)}},
      else: {puz.hint, %{state | current: if(n > 1, do: cur), tries: n - 1}}
  end
end
