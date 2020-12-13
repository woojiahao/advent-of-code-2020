defmodule Solution do
  defp load_data() do
    data = File.read!("data.txt") |> String.split("\n", trim: true)

    [earliest, buses] = data

    earliest! = earliest |> String.to_integer()

    buses! =
      buses
      |> String.split(",", trim: true)
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer(&1))

    {earliest!, buses!}
  end

  defp solve({earliest, buses}) do
    [b, _] =
      buses
      |> Enum.map(fn bus -> [bus, earliest / bus - div(earliest, bus)] end)
      |> Enum.max_by(fn [_bus, f] -> f end)

    (b * (div(earliest, b) + 1) - earliest) * b
  end

  def part_one() do
    load_data() |> solve()
  end
end
