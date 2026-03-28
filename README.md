# PuzzleGame

A CLI escape-room puzzle game. Play through YAML-defined stories, solve riddles, escape!

## Server

```bash
mix deps.get   # Install
mix start      # Play
mix start path/to/story.yml   # Custom story
```

## Client

```bash
nc localhost 4049
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
```

## Architecture

- `Start` - Mix Task
- `Server` - Game loop & I/O
- `Game` - Game state & Logic
- `Story` / `Story.Importer` - Loads puzzles (YAML)
- `Puzzle` / `Meta` - Data structs
