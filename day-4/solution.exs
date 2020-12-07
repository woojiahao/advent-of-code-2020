defmodule Solution do
  defp convert([k, v]) when k in ~w(byr iyr eyr cid) do
    case Integer.parse(v) do
      {n, ""} -> {String.to_atom(k), n}
      _ -> {String.to_atom(k), :error}
    end
  end

  defp convert(["hgt", hgt]), do: {:hgt, Integer.parse(hgt)}

  defp convert(["pid", pid]) do
    case pid |> String.graphemes() |> Enum.all?(&(Integer.parse(&1) != :error)) do
      true -> {:pid, pid}
      _ -> {:pid, :error}
    end
  end

  defp convert([k, v]), do: {String.to_atom(k), v}

  def validate_fields([:byr, :cid, :ecl, :eyr, :hcl, :hgt, :iyr, :pid]), do: true
  def validate_fields([:byr, :ecl, :eyr, :hcl, :hgt, :iyr, :pid]), do: true
  def validate_fields(_), do: false

  def validate_byr(y) when y in 1920..2002, do: :ok
  def validate_byr(_), do: {:error, :bad_byr}

  def validate_iyr(y) when y in 2010..2020, do: :ok
  def validate_iyr(_), do: {:error, :bad_iyr}

  def validate_eyr(y) when y in 2020..2030, do: :ok
  def validate_eyr(_), do: {:error, :bad_eyr}

  def validate_hgt({height, "cm"}) when height in 150..193, do: :ok
  def validate_hgt({height, "in"}) when height in 59..76, do: :ok
  def validate_hgt(_), do: {:error, :bad_hgt}

  def validate_hcl(<<"#", rest::binary-size(6)>>) do
    case Regex.match?(~r/^[a-fA-F\d]+$/, rest) do
      true -> :ok
      _ -> {:error, :bad_hcl}
    end
  end

  def validate_hcl(_), do: {:error, :bad_hcl}

  def validate_ecl(ecl) when ecl in ~w(amb blu brn gry grn hzl oth), do: :ok
  def validate_ecl(_), do: {:error, :bad_ecl}

  def validate_pid(<<_::binary-size(9)>>), do: :ok
  def validate_pid(_), do: {:error, :bad_pid}

  def validate_fields_input(fields) do
    with :ok <- validate_byr(fields[:byr]),
         :ok <- validate_iyr(fields[:iyr]),
         :ok <- validate_eyr(fields[:eyr]),
         :ok <- validate_hgt(fields[:hgt]),
         :ok <- validate_hcl(fields[:hcl]),
         :ok <- validate_ecl(fields[:ecl]),
         :ok <- validate_pid(fields[:pid]) do
      true
    else
      {:error, _error} -> false
    end
  end

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
    |> Enum.filter(&validate_fields(&1 |> Map.keys() |> Enum.sort()))
    |> Enum.count(&validate_fields_input(&1))
  end
end
