defmodule Solution do
  defp load_data() do
    # We can assume that there are no duplicates
    data =
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    [0] ++ data ++ [(data |> Enum.max()) + 3]
  end

  defp zip_with_next(lst) do
    lst |> Enum.zip(lst |> Enum.slice(1, length(lst) - 1))
  end

  def part_one() do
    %{1 => n, 3 => m} =
      load_data()
      |> Enum.sort()
      |> zip_with_next()
      |> Enum.map(fn {x, y} -> y - x end)
      |> Enum.frequencies()

    n * m
  end
end
