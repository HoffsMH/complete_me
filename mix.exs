defmodule CompleteMe.MixProject do
  use Mix.Project

  def project do
    [
      app: :complete_me,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: Coverex.Task]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:benchee, ">= 0.0.0", only: :dev},
      {:coverex, "~> 1.4.10", only: :test},
      {:poolboy, ">= 0.0.0"},
      {:deep_merge, "~> 1.0", override: true}
    ]
  end
end
