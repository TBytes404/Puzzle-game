defmodule PuzzleGame.Game.Puzzle do
  @puzzles %{
    entrance: %{
      quest: "You see a door with a riddle etched into it.\n
  I speak without a mouth and hear without ears.
  I have nobody, but i come alive with wind.
  What am I?",
      hint: "Wrong answer. Hint: You hear it in the caves-",
      answer: "echo",
      pass: "The door opens!",
      next: :final
    },
    final: %{
      quest: "You enter the final room.\n
  A box asks: what number comes next? 2, 4, 8, 16, ?",
      hint: "Incorrect. Think powers of two.",
      answer: "32",
      pass: "You solved all puzzles and escaped!"
    }
  }

  def get(label), do: @puzzles[label]

  def exists(label),
    do: if(Map.has_key?(@puzzles, label), do: label, else: nil)
end
