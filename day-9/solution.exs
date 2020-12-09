defmodule Solution do
  defp load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

  defp combinations(data), do: for(x <- data, y <- data, x != y, do: [x, y])

  defp is_valid(data, preamble_size, pos) when pos >= length(data), do: {:error, :invalid_pos}
  defp is_valid(data, preamble_size, pos) when pos < preamble_size, do: {:error, :invalid_pos}

  # Returns if the value at given `pos` is a valid number from the given preamble above
  defp is_valid(data, preamble_size, pos) do
    # From the current pos, count backwards and generate all combinations of the preamble
    valid =
      data
      |> Enum.slice(pos - preamble_size, preamble_size)
      |> combinations()
      |> Enum.map(fn [x, y] -> x + y end)

    Enum.at(data, pos) in valid
  end

  def part_one() do
    data = load_data()
    preamble_size = 25

    data
    |> Enum.at(
      (preamble_size..(length(data) - 1)
       |> Enum.map(&is_valid(data, preamble_size, &1))
       |> Enum.find_index(&(!&1))) + preamble_size
    )
  end
end
