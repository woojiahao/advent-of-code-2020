defmodule Solution do
  defp validate(input) do
    [min, max, letter, password] = Regex.run(~r/^(\d+)-(\d+) (\w): (\w+)$/, input, capture: :all_but_first)
    freq = password |> String.graphemes() |> Enum.frequencies() |> Map.get(letter)
    freq >= String.to_integer(min) and freq <= String.to_integer(max) 
  end

  def partOne(), do: File.read!("data.txt") |> String.split("\n", trim: true) |> Enum.count(&validate/1) 
end
