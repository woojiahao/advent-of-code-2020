defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n\n", trim: true)
  @fields MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

  def part_one() do
    @data 
      |> Enum.map(fn x -> String.split(x, ~r{[\n|\s]}) end) 
      |> Enum.map(fn x -> x |> Enum.map(fn y -> String.split(y, ":") |> List.first() end) |> MapSet.new() end)
      |> Enum.count(fn x -> MapSet.intersection(x, @fields) |> MapSet.size() == MapSet.size(@fields) end)
  end
end
