# BeamToEx

[WIP] This a command line tool that takes a beam or erl file and converts it into elixir
code. There are a lot of codes to be mapped but it works with basic examples.

This uses [beam_to_ex_ast](https://github.com/olafura/beam_to_ex_ast)

## Installation

mix deps.get

mix escript.build

Then you have new command to play with:
./beam_to_ex --beam beam_file.beam
./beam_to_ex --erl erlang_file.erl
