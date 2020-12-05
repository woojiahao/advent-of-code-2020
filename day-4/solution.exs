defmodule Passport do
  defstruct [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
end

defmodule Solution do
  @data File.read!("data.txt") 
    |> String.split("\n\n", trim: true) 
    |> Enum.map(fn x -> String.split(x, ~r{[\n|\s]}, trim: true) end) 
    |> Enum.map(fn x -> Enum.map(x, fn y -> String.split(y, ":", trim: true) end) end)
    |> Enum.map(fn x -> struct(Passport, Map.new(x, fn [k, v] -> {String.to_atom(k), v} end)) end)

  def part_one() do
    @data |> Enum.count(fn x -> x |> Map.values() |> Enum.all?(fn y -> y != nil end) end)
  end

  def part_two() do
    nil
  end
end
