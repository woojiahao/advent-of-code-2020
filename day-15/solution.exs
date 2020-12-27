defmodule Solution do
  defp load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

  defp append(lst, v), do: [v | lst |> Enum.reverse()] |> Enum.reverse()

  defp rfind(lst, v, i) do
    {_, pos} =
      lst
      |> Stream.with_index()
      |> Stream.filter(fn {a, _i} -> a == v end)
      |> Enum.reverse()
      |> Enum.at(i - 1)

    pos
  end

  defp solve(backlog, i, n) when i == n, do: backlog |> List.last()

  defp solve(backlog, i, n) do
    prev = backlog |> List.last()

    elem =
      if backlog |> Enum.filter(&(&1 == prev)) |> length() == 1,
        do: 0,
        else: length(backlog) - rfind(backlog, prev, 2) - 1

    solve(append(backlog, elem), i + 1, n)
  end

  def part_one() do
    data = load_data()
    data |> solve(length(data), 2020)
  end

  def part_two() do
    data = load_data()
    data |> solve(length(data), 30_000_000)
  end
end
