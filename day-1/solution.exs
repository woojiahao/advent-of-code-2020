defmodule Solution do 
  defp combinations(elems), do: for x <- elems, y <- elems, x != y, do: [x, y]
  def partOne() do
    File.read!("data.txt") 
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> combinations
      |> Enum.filter(fn x -> List.first(x) + List.last(x) == 2020 end)
      |> List.first
      |> List.foldl(1, fn acc, x -> x * acc end)
  end
end
