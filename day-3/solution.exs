defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n", trim: true)

  defp is_tree(row, i, right, down) do
    raw_col =
      Stream.cycle(0..(String.length(row) - 1))
      |> Enum.take(div(i, down) * right)
      |> List.last()

    col = if raw_col + 1 == String.length(row), do: 0, else: raw_col + 1
    row |> String.graphemes() |> Enum.at(col) == "#"
  end

  defp traverse(rows, right, down) do
    1..length(rows)
    |> Enum.zip(rows)
    |> Enum.filter(&(rem(elem(&1, 0), down) == 0))
    |> Enum.count(fn {i, row} -> is_tree(row, i, right, down) end)
  end

  def part_one() do
    [_ | d] = @data
    traverse(d, 3, 1)
  end

  def part_two() do
    [_ | d] = @data
    s1 = traverse(d, 1, 1)
    s2 = traverse(d, 3, 1)
    s3 = traverse(d, 5, 1)
    s4 = traverse(d, 7, 1)
    s5 = traverse(d, 1, 2)
    s1 * s2 * s3 * s4 * s5
  end
end
