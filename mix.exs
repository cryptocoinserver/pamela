defmodule Pamela.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pamela,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  # :y
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Pamela.Application, []},
      extra_applications: [:nadia, :logger, :runtime_tools, :binance, :timex]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:phoenix_pubsub, "~> 2.0.0"},
      {:phoenix_ecto, "~> 4.2.1"},
      {:ecto_sql, "~> 3.5.3"},
      {:postgrex, ">= 0.15.7"},
      {:gettext, "~> 0.18.2"},
      {:plug_cowboy, "~> 2.4.1"},
      {:timex, "~> 3.6.3"},
      {:nadia, "~> 0.7.0"},
      {:binance, "~> 0.7.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
