defmodule Solution do
  @data File.read!("data.txt") 
    |> String.split("\n\n", trim: true) 
    |> Enum.map(fn x -> String.split(x, ~r{[\n|\s]}, trim: true) end) 
    |> Enum.map(fn x -> Enum.map(x, fn y -> String.split(y, ":", trim: true) end) end)
    |> Enum.map(fn x -> Map.new(x, fn [k, v] -> {k, v} end) end)

  @fields MapSet.new(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])

  def part_one() do
    @data |> Enum.count(fn x -> 
      MapSet.intersection(MapSet.new(Map.keys(x)), @fields) 
      |> MapSet.size() == MapSet.size(@fields) 
    end)
  end

  def part_two() do
    nil
  end
end
