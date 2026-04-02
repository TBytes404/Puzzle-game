# PuzzleGame

A TCP based CLI escape-room puzzle game. Play through YAML-defined stories, solve riddles, escape!

## Server

```bash
mix deps.get   # Install
mix run -e "PuzzleGame.Endpoint.start"       # Start Server
```

## Client

```bash
 # Start interactive session
nc localhost 4049

# Upload a story file | COMMAND: UPLOAD <BINARY_SIZE>
f=path_to_story_file.yaml;
s=$(stat -f %z $f) # Macos
s=$(stat -c %f $f) # Linux
echo "upload $s" | nc localhost 4049 < $f;
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
