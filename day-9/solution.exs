defmodule Solution do
  @preamble_size 25
  @data File.read!("data.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)

  defp combinations(data), do: for(x <- data, y <- data, x != y, do: [x, y])

  defp is_valid(data, __size, pos) when pos >= length(data), do: {:error, :invalid_pos}
  defp is_valid(_, preamble_size, pos) when pos < preamble_size, do: {:error, :invalid_pos}

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

  defp find_contiguous_sum(data, _, _, cur, _, _)
       when cur >= length(data),
       do: {:error, :cur_exceed}

  defp find_contiguous_sum(data, _, start, _, _, _)
       when start >= length(data),
       do: {:error, :start_exceed}

  defp find_contiguous_sum(data, target, start, cur, range, sum) when sum < target do
    values = [data |> Enum.at(cur) | range] |> Enum.reverse()

    find_contiguous_sum(data, target, start, cur + 1, values, values |> Enum.sum())
  end

  defp find_contiguous_sum(data, target, start, _, _, sum) when sum > target do
    find_contiguous_sum(data, target, start + 1, start + 1, [], 0)
  end

  defp find_contiguous_sum(_, target, _, _, range, sum)
       when target == sum and length(range) > 1,
       do: range

  # If this clause is reached, it means that the search has already reached
  # the target, which means that any subsequent numbers will always be larger
  # than the target. There's no point in continuing operation if this happens
  defp find_contiguous_sum(_, target, _, _, range, sum)
       when target == sum and length(range) <= 0,
       do: {:error, :invalid_range}

  def part_one() do
    @data
    |> Enum.at(
      (@preamble_size..(length(@data) - 1)
       |> Enum.map(&is_valid(@data, @preamble_size, &1))
       |> Enum.find_index(&(!&1))) + @preamble_size
    )
  end

  def part_two() do
    @data
    |> find_contiguous_sum(part_one(), 0, 0, [], 0)
    |> Enum.min_max()
    |> Tuple.to_list()
    |> Enum.sum()
  end
end
