defmodule PuzzleGame.Story.Puzzle do
  @type t() :: %__MODULE__{}
  defstruct [:label, :quest, :answer, :hint, :pass, :next, tries: 0]

  @spec check_answer(t(), binary()) :: {:pass | :hint | :fail, t()}
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
