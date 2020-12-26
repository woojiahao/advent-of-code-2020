defmodule Solution do
  defp load_data() do
    data = File.read!("data.txt") |> String.split("\n", trim: true)

    [earliest, buses] = data

    earliest! = earliest |> String.to_integer()

    buses! =
      buses
      |> String.split(",", trim: true)
      |> Stream.with_index()
      |> Enum.filter(&(elem(&1, 0) != "x"))
      |> Enum.map(fn {b, i} -> {i, String.to_integer(b)} end)

    {earliest!, buses!}
  end

  defp solve({earliest, buses}) do
    [b, _] =
      buses
      |> Enum.map(fn {_i, bus} -> [bus, earliest / bus - div(earliest, bus)] end)
      |> Enum.max_by(fn [_bus, f] -> f end)

    (b * (div(earliest, b) + 1) - earliest) * b
  end

  defp part_one() do
    load_data() |> solve()
  end

  defp at(l, i), do: l |> Enum.at(i)

  # Refer to article for explanation: https://brilliant.org/wiki/extended-euclidean-algorithm/
  defp extgcd(_a, _b, _s, _t, r, old_s, old_t, _old_r) when r == 0, do: {old_s, old_t}

  defp extgcd(a, b, s, t, r, old_s, old_t, old_r) do
    q = div(old_r, r)
    extgcd(a, b, old_s - q * s, old_t - q * t, old_r - q * r, s, t, r)
  end

  defp solve!({_, buses}) do
    n_i = buses |> Enum.map(&elem(&1, 1))
    # Set the remainder to be bus_id - index
    a_i = buses |> Enum.map(&elem(&1, 0))
    y = n_i |> List.foldl(1, fn x, acc -> acc * x end)
    y_i = n_i |> Enum.map(&div(y, &1))
    i = 0..(length(n_i) - 1)

    # The value of z_i is computed by taking the modular inverse of the equation ax ~= 1 (mod b)
    z_i =
      i
      |> Enum.map(fn j ->
        a = at(y_i, j)
        b = at(n_i, j)
        {z, _} = extgcd(a, b, 0, 1, b, 1, 0, a)
        rem(rem(z, b) + b, b)
      end)

    x =
      i
      |> Enum.map(fn j ->
        a = at(a_i, j)
        y = at(y_i, j)
        z = at(z_i, j)
        a * y * z
      end)
      |> Enum.sum()

    # Refer here for why need to subtract y: https://www.reddit.com/r/adventofcode/comments/key1da/2020_day_13_part_2_really_struggling_to/gge73cs?utm_source=share&utm_medium=web2x&context=3
    y - rem(x, y)
  end

  def part_two() do
    load_data() |> solve!()
    # extgcd(1432, 123_211, 0, 1, 123_211, 1, 0, 1432)
    # solve!({[], [{1, 2}, {2, 3}, {3, 5}, {4, 7}]})
    # extgcd(102, 38, 0, 1, 38, 1, 0, 102)
  end
end
