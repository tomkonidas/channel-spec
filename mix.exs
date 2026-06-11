defmodule ChannelSpec.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :channel_spec,
      version: @version,
      elixir: "~> 1.19",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:styler, "~> 1.11", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      lint: ["compile --warnings-as-errors", "format", "dialyzer"]
    ]
  end
end
