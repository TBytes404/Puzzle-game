# PuzzleGame

A CLI escape-room puzzle game. Play through YAML-defined stories, solve riddles, escape!

```bash
mix deps.get   # Install
mix start      # Play
mix start path/to/story.yml   # Custom story
```

## Creating Stories

```yaml
__meta__:
  title: My Story
  author: YourName
  tries: 3
  entry: start

start:
  quest: "Your riddle here?"
  answer: answer
  hint: "Wrong, try again"
  pass: "Correct!"
  next: end

end:
  quest: "Final puzzle?"
  answer: final
  hint: "Hint"
  pass: "You escaped!"
  next: ~
```

## Architecture

- `Cli` - Game loop & I/O
- `Game` - State machine
- `Provider` - Loads puzzles (YAML)
- `Puzzle` / `Meta` - Data structs
