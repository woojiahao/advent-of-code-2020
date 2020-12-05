defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n", trim: true)

  def part_one() do
    [_ | d] = @data
    Enum.zip(1..(length(d)), d) 
      |> Enum.count(fn {i, x} -> 
        raw_col = Stream.cycle(0..String.length(x)-1) |> Enum.take(i*3) |> List.last()
        col = if raw_col+1 == String.length(x), do: 0, else: raw_col+1
        x |> String.graphemes() |> Enum.at(col) == "#" 
      end)
  end
end
