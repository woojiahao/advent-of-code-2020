defmodule Solution do
  def load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&split_input/1)
      |> Enum.map(fn [x, y, letter, pass] ->
        [String.to_integer(x), String.to_integer(y), letter, pass]
      end)

  defp split_input(input),
    do: Regex.run(~r/^(\d+)-(\d+) (\w): (\w+)$/, input, capture: :all_but_first)

  defp validate_frequency([min, max, letter, password]) do
    freq = password |> String.graphemes() |> Enum.frequencies() |> Map.get(letter)
    freq in min..max
  end

  defp validate_policy([x, y, letter, password]) do
    [first, second] = [x, y] |> Enum.map(&String.at(password, &1 - 1))
    (first == letter or second == letter) and first != second
  end

  def part_one(), do: load_data() |> Enum.count(&validate_frequency/1)
  def part_two(), do: load_data() |> Enum.count(&validate_policy/1)
end
