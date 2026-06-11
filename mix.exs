defmodule ChannelSpec.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :channel_spec,
      version: @version,
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
