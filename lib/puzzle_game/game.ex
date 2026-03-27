defmodule PuzzleGame.Game do
  alias PuzzleGame.Puzzle
  alias PuzzleGame.Provider

  defstruct provider: %Provider{}, puzzle: %Puzzle{}

  def start(provider) do
    meta = Provider.meta(provider)
    IO.puts("\n" <> meta.title <> "\t\tby " <> meta.author)

    %__MODULE__{provider: provider, puzzle: Provider.get_puzzle(provider)}
    |> play()
  end

  defp play(%{puzzle: nil}), do: :ok

  defp play(%{puzzle: puz} = state) do
    IO.puts("")
    puz.quest |> IO.puts()

    {reply, state} = answer(state, IO.gets("> "))
    IO.puts(reply)

    play(state)
  end

  defp answer(%__MODULE__{provider: p, puzzle: puz} = state, input) do
    if puz.answer |> normalize() == input |> normalize(),
      do: {puz.pass, %{state | puzzle: Provider.get_puzzle(p, puz.next)}},
      else: {puz.hint, %{state | puzzle: if(puz.tries > 1, do: %{puz | tries: puz.tries - 1})}}
  end

  defp normalize(answer) do
    answer
    |> to_string()
    |> String.trim()
    |> String.downcase()
  end
end
