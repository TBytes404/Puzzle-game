defmodule PuzzleGame.Puzzle do
  defstruct [:label, :quest, :answer, :hint, :pass, :next, tries: 0]

  @doc "Check if input matches puzzle answer, returns {:pass or :hint or :fail, message, puzzle}"
  def check_answer(%__MODULE__{answer: answer, tries: tries} = puzzle, input) do
    if normalize(answer) == normalize(input) do
      {:pass, puzzle}
    else
      if tries > 1,
        do: {:hint, %{puzzle | tries: tries - 1}},
        else: {:fail, puzzle}
    end
  end

  defp normalize(term),
    do: term |> to_string() |> String.trim() |> String.downcase()
end
