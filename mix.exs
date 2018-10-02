defmodule RpiVideo.MixProject do
  use Mix.Project

  def project do
    [
      app: :rpi_video,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      compilers: [:elixir_make | Mix.compilers()]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.4", runtime: false},
      {:ex_doc, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    "Playback video on your Raspberry Pi"
  end

  defp package do
    [
      name: :rpi_video,
      files: ["lib", "src/*.[ch]", "Makefile", "test", "priv", "mix.exs", "README.md", "LICENSE"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/fhunleth/rpi_video"}
    ]
  end
end
