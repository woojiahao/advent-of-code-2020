defmodule Solution do
  def load_data(), do: File.read!("data.txt") |> String.split("\n\n", trim: true)

  def part_one() do
    load_data()
    |> Enum.map(&String.split(&1, ~r{[\n|\s]}, trim: true))
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end
end
