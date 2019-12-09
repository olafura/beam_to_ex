defmodule BeamToEx do
  def main(args) do
    args |> parse_args |> convert
  end

  defp parse_args(args) do
    {options, _, _} =
      OptionParser.parse(args,
        switched: [beam: :string, erl: :string]
      )

    options
  end

  def convert(options) do
    mod_beam =
      case Keyword.has_key?(options, :erl) do
        true ->
          {:ok, mod_beam} = :epp.parse_file(String.to_char_list(options[:erl]), [])
          mod_beam

        false ->
          {:ok, {_, [{:abstract_code, {_, mod_beam}}]}} =
            :beam_lib.chunks(String.to_char_list(options[:beam]), [:abstract_code])

          mod_beam
      end

    mod_ast = BeamToExAst.convert(mod_beam)
    Macro.to_string(mod_ast) |> make_pretty |> IO.puts()
  end

  def make_pretty(ast) do
    ast = Regex.replace(~r/(def)\(([a-zA-Z0-9]+\([a-zA-Z0-9]*\))\)/, ast, "\\1 \\2")
    Regex.replace(~r/(defmodule)\(([a-zA-Z0-9]+)\)/, ast, "\\1 \\2")
  end
end
