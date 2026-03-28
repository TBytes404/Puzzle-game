defmodule PuzzleGame.Puzzle do
  defstruct [:quest, :answer, :hint, :pass, :next, tries: 0]

  @doc "Check if input matches puzzle answer"
  def correct?(%__MODULE__{answer: answer}, input),
    do: normalize(answer) == normalize(input)

  @doc "Decrement tries, returns nil if exhausted"
  def decrement_tries(%__MODULE__{tries: tries} = puzzle),
    do: if(tries > 1, do: %{puzzle | tries: tries - 1})

  defp normalize(term),
    do: term |> to_string() |> String.trim() |> String.downcase()
end
