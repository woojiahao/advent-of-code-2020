defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n", trim: true)

  defp split_input(input), do: Regex.run(~r/^(\d+)-(\d+) (\w): (\w+)$/, input, capture: :all_but_first)

  defp validate_frequency(input) do
    [min, max, letter, password] = split_input(input)
    freq = password |> String.graphemes() |> Enum.frequencies() |> Map.get(letter)
    freq >= String.to_integer(min) and freq <= String.to_integer(max) 
  end

  defp validate_policy(input) do
    [first, second, letter, password] = split_input(input)
    first_letter = String.at(password, String.to_integer(first)-1)
    second_letter = String.at(password, String.to_integer(second)-1)
    (first_letter == letter or second_letter == letter) and first_letter != second_letter
  end

  def part_one(), do: @data |> Enum.count(&validate_frequency/1) 
  def part_two(), do: @data |> Enum.count(&validate_policy/1)
end
