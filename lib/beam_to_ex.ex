defmodule BeamToEx do
  def main(args) do
    args |> parse_args |> convert
  end

  defp parse_args(args) do
    {options, _, _} =
      OptionParser.parse(args,
        switches: [beam: :string, erl: :string]
      )

    options
    |> Map.new()
  end

  def convert(options) do
    mod_beam =
      case options do
        %{erl: erl} ->
          {:ok, mod_beam} = :epp.parse_file(String.to_charlist(erl), [])
          mod_beam

        %{beam: beam} ->
          {:ok, {_, [{:abstract_code, {_, mod_beam}}]}} =
            :beam_lib.chunks(String.to_charlist(beam), [:abstract_code])

          mod_beam

        _ ->
          false
      end

    if mod_beam do
      mod_ast = BeamToExAst.convert(mod_beam)

      code = Macro.to_string(mod_ast) |> make_pretty()

      try do
        code
        |> Code.format_string!(migrate: true)
        |> IO.puts()
      rescue
        _ -> IO.puts(code)
      end
    else
      IO.puts("Either user --erl or --beam")
    end
  end

  def make_pretty(ast) do
    ast = Regex.replace(~r/(def)\(([a-zA-Z0-9]+\([a-zA-Z0-9]*\))\)/, ast, "\\1 \\2")
    Regex.replace(~r/(defmodule)\(([a-zA-Z0-9]+)\)/, ast, "\\1 \\2")
  end
end
