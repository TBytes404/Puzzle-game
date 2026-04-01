defmodule PuzzleGame.Game do
  @moduledoc "Game state machine - pure logic, no IO"

  alias PuzzleGame.Puzzle
  alias PuzzleGame.Session
  alias PuzzleGame.Story
  alias PuzzleGame.Story.Store

  @behaviour Session

  defstruct [:story, :puzzle]

  @impl true
  def init() do
    story = Store.load("locked-chambers")

    game = %__MODULE__{
      story: story,
      puzzle: Story.entry_puzzle(story)
    }

    {game, header(story) <> prompt(game.puzzle)}
  end

  @impl true
  def handle(%__MODULE__{story: story, puzzle: puzzle} = game, input) do
    case Story.next_puzzle(story, puzzle, input) do
      {nil, msg} -> {nil, msg <> "\n"}
      {puzzle, msg} -> {%{game | puzzle: puzzle}, msg <> prompt(puzzle)}
    end
  end

  @impl true
  def finish(_), do: nil

  defp header(%Story{meta: meta}),
    do: "\n#{meta.title}\t\tby #{meta.author}"

  defp prompt(%Puzzle{} = puzzle) do
    "\n\n#{puzzle.label}> #{puzzle.quest}\nanswer> "
  end
end
