defmodule PuzzleGame.Session.Game do
  @moduledoc "Game state machine - pure logic, no IO"

  alias PuzzleGame.Story
  alias PuzzleGame.Story.Builder
  alias PuzzleGame.Story.Puzzle
  alias PuzzleGame.Storage
  alias PuzzleGame.Session
  alias PuzzleGame.Session.Menu

  @behaviour Session

  defstruct [:story, :puzzle]

  @impl true
  def init() do
    story =
      Storage.load("locked-chambers")
      |> Builder.from_map()

    game = %__MODULE__{
      story: story,
      puzzle: Story.entry_puzzle(story)
    }

    {game, header(story) <> prompt(game.puzzle)}
  end

  @impl true
  def handle(%__MODULE__{story: story, puzzle: puzzle} = game, input) do
    case Story.next_puzzle(story, puzzle, input) do
      {nil, msg} -> {{:switch, Menu}, msg <> "\n"}
      {puzzle, msg} -> {{:continue, %{game | puzzle: puzzle}}, msg <> prompt(puzzle)}
    end
  end

  @impl true
  def stop(_), do: nil

  defp header(%Story{meta: meta}),
    do: "\n#{meta.title}\t\tby #{meta.author}"

  defp prompt(%Puzzle{} = puzzle) do
    "\n\n#{puzzle.label}> #{puzzle.quest}\nanswer> "
  end
end
