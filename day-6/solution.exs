defmodule Solution do
  def load_data(), do: File.read!("data.txt") |> String.split("\n\n", trim: true)

  def part_one() do
    load_data()
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end
end
