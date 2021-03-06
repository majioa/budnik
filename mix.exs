defmodule Budnik.MixProject do
  use Mix.Project

  def project do
    [
      app: :budnik,
      version: "0.1.0",
      elixir: "~> 1.10",
# start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
# mod: { BudnikCore, [] },
      applications: [:dotenv, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nadia, "~> 0.7"},
      {:dotenv, "~> 3.0.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
