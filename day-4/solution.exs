defmodule Solution do
  defp convert([k, v]) when k in ~w(byr iyr eyr pid) do
    case Integer.parse(v) do
      {n, ""} -> {String.to_atom(k), n}
      _ -> {String.to_atom(k), :error}
    end
  end

  defp convert(["hgt", v]), do: {:hgt, Integer.parse(v)}
  defp convert([k, v]), do: {String.to_atom(k), v}

  defp has_fields(passport), do: passport |> Map.values() |> Enum.all?(fn y -> y != nil end)

  def validate_byr(year) when year in 1920..2002, do: :ok
  def validate_iyr(year) when year in 2010..2020, do: :ok
  def validate_eyr(year) when year in 2020..2030, do: :ok

  def validate_fields([:byr, :cid, :ecl, :eyr, :hcl, :hgt, :iyr, :pid]), do: true
  def validate_fields([:byr, :ecl, :eyr, :hcl, :hgt, :iyr, :pid]), do: true
  def validate_fields(_), do: false

  def load_data() do
    File.read!("data.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, ~r{[\n|\s]}, trim: true))
    |> Enum.map(fn x -> Enum.map(x, &String.split(&1, ":", trim: true)) end)
    |> Enum.map(fn x -> Enum.map(x, &convert/1) end)
    |> Enum.map(&Enum.into(&1, %{}))
  end

  def part_one(), do: load_data() |> Enum.count(&validate_fields(&1 |> Map.keys() |> Enum.sort()))

  def part_two() do
    load_data()
    |> Enum.map(fn x ->
      if not has_fields(x) do
        false
      else
        true
      end
    end)
  end
end
