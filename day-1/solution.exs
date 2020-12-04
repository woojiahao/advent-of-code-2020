defmodule Solution do 
  defp combinations(elems, size) when size == 2, do: for x <- elems, y <- elems, x != y, do: [x, y]
  defp combinations(elems, size) when size == 3, do: for x <- elems, y <- elems, z <- elems, x != y, y != z, x != z, do: [x, y, z]
  defp solve(size \\ 2) do
    File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> combinations(size)
      |> Enum.filter(fn x -> Enum.sum(x) == 2020 end)
      |> List.first 
      |> List.foldl(1, fn acc, x -> x * acc end)
  end 

  def partOne() do
    solve()
  end

  def partTwo() do
    solve(3)
  end
end
