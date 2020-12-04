defmodule Solution do 
  defp combinations(elems, size) when size == 2, do: for x <- elems, y <- elems, x != y, do: [x, y]
  defp combinations(elems, size) when size == 3, do: for x <- elems, y <- elems, z <- elems, x != y, y != z, x != z, do: [x, y, z]
  defp data(size \\ 2) do
    File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> combinations(size)
  end 
  defp acc(lst) do
    lst 
      |> List.first 
      |> List.foldl(1, fn acc, x -> x * acc end)
  end

  def partOne() do
    data() |> Enum.filter(fn [x, y] -> x + y == 2020 end) |> acc
  end

  def partTwo() do
    data(3) |> Enum.filter(fn [x, y, z] -> x + y + z == 2020 end) |> acc
  end
end
