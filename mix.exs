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

  # Run "mix help compile.app" to learn about applications.
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
      {:earmark, "~> 1.2.2", only: :dev},
      {:ex_doc, "~> 0.18.2", only: :dev},
      {:coverex, "~> 1.4.15", only: :test},
      {:benchee, "~> 0.12.0", only: [:test, :dev]},
      {:benchee_html, "~> 0.4", only: :dev}
    ]
  end
end
