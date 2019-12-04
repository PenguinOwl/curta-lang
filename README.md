# curta

Currently only contains a REPL, but will be able to read from file once I finish the parser.

## Installation

The good old classic
```
git clone https://github.com/PenguinOwl/curta-lang
cd curta-lang
shards build
./bin/curta-lang
```

## Usage

```
reg = registers
res = result readout
rev = revolution counter

get (reg|res|rev) <number>
set reg <index> to number
set crank to up
set crank to down
set lever to forward
set lever to reverse
read (reg|res|rev)
turn

# Coming soon
goto
skip
```

## Development

Write it up into a PR and I'll see what I can do.

## Contributing

1. Fork it (<https://github.com/PenguinOwl/curta-lang/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [PenguinOwl](https://github.com/PenguinOwl) - creator and maintainer
