defmodule Solution do
  defp load_data(), do: File.read!("data.txt") |> String.split("\n\n", trim: true)

  def part_one() do
    load_data()
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.uniq/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def part_two() do
    load_data()
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(fn answers ->
      answers
      |> Enum.flat_map(&String.graphemes/1)
      |> Enum.frequencies()
      |> Enum.filter(&(elem(&1, 1) == length(answers)))
      |> length()
    end)
    |> Enum.sum()
  end
end
