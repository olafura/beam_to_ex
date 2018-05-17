defmodule BeamToEx.Mixfile do
  use Mix.Project

  def project do
    [app: :beam_to_ex,
     version: "0.2.0",
     elixir: "~> 1.3-dev",
     compilers: Mix.compilers ++ [:protocol_ex],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: BeamToEx],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # {:beam_to_ex_ast, "~> 0.3.0"}
      {:beam_to_ex_ast, path: "../beam_to_ex_ast"}
    ]
  end
end
