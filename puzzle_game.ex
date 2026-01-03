defmodule PuzzleGame do
  def start do
    IO.puts("\n Welcome to the Locked Chamber")
    IO.puts("Solve the puzzles to escape!\n")

    state = %{room: :entrance}
    play(state)
  end

  def play(%{room: :entrance} = state) do
    IO.puts("You see a door with a riddle etched into it.")
    IO.puts("""
    I speak without a mouth and hear without ears.
    I have nobody, but i come alive with wind.
    What am I?
    """)

    answer =
    IO.gets("> ")
    |> String.trim()
    |> String.downcase()
    
    case answer do
      "echo" ->
        IO.puts("\n The door opens!\n")
        play(%{state | room: :final})

        _->
          IO.puts("\n Wrong answer. Hint: You hear it in the caves-\n")
          play(state)
        end
      end

      def play(%{room: :final}) do
        IO.puts("You enter the final room.")
        IO.puts("A box asks: what number comes next? 2, 4, 8, 16, ?")

        answer =
        IO.gets("> ")
        |> String.trim()

        case answer do
          "32" ->
            IO.puts("\n You solved all puzzles and escaped!")
            :ok

            _->
              IO.puts("\n Incorrect. Think powers of two.\n")
              play(%{room: :final})
            end
          end
        end

        PuzzleGame.start()