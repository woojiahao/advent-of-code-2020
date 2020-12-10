defmodule Solution do
  defp combinations(elems, size)
       when size == 2,
       do: for(x <- elems, y <- elems, x != y, do: [x, y])

  defp combinations(elems, size)
       when size == 3,
       do: for(x <- elems, y <- elems, z <- elems, x != y, y != z, x != z, do: [x, y, z])

  defp solve(size \\ 2) do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> combinations(size)
    |> Enum.find(&(Enum.sum(&1) == 2020))
    |> List.foldl(1, &(&1 * &2))
  end

  def part_one(), do: solve()
  def part_two(), do: solve(3)
end
