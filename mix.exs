defmodule ChannelSpec.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :channel_spec,
      version: @version,
      elixir: "~> 1.19",
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
