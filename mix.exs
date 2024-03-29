defmodule Nested.MixProject do
  use Mix.Project

  @name "nested_ex"
  @version "0.1.1"
  @repo_url "https://github.com/dgulinobw/nested_ex"

  def project do
    [
      app: :nested_ex,
      version: @version,
      description: "Library to handle nested maps",
      package: package(),
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      name: @name,
      deps: deps()
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:lettuce, "~> 0.2.0", only: [:dev,:qa]}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url,
      }
    ]
  end
end
