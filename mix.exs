defmodule Delivery.Library.Mixfile do
  use Mix.Project

  def project do
    [app: :deliverylib,
     version: "0.0.3",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     name: "运单模块API",
     deps: deps]
  end

  defp deps do
    [
      {:poison, "~> 2.0"},
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
