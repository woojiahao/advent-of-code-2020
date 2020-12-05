defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n", trim: true)

  defp split_input(input), do: Regex.run(~r/^(\d+)-(\d+) (\w): (\w+)$/, input, capture: :all_but_first)

  defp validate_frequency(input) do
    [min, max, letter, password] = split_input(input)
    freq = password |> String.graphemes() |> Enum.frequencies() |> Map.get(letter)
    freq in String.to_integer(min)..String.to_integer(max)
  end

  defp validate_policy(input) do
    [x, y, letter, password] = split_input(input)
    [first, second] = [x, y] |> Enum.map(fn x -> String.at(password, String.to_integer(x)-1) end)
    (first == letter or second == letter) and first != second
  end

  def part_one(), do: @data |> Enum.count(&validate_frequency/1) 
  def part_two(), do: @data |> Enum.count(&validate_policy/1)
end
