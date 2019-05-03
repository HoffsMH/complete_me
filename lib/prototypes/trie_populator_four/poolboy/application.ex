defmodule TriePopulatorFour.Application do
  @moduledoc false

  use Application

  defp poolboy_config do
    [
      {:name, {:local, :worker}},
      {:worker_module, TriePopulatorFour.Worker},
      {:size, 5},
      {:max_overflow, 2}
    ]
  end

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: TriePopulatorFour.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
