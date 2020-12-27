defmodule Optimised do
  defp load_data(),
    do:
      File.read!("dummy.txt")
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

  defp rfind(lst, v) do
    [_ | rest] = lst |> Enum.filter(&(&1 != nil)) |> Enum.reverse()

    length(rest) - (rest |> Enum.find_index(&(&1 == v)))
  end

  def solve(backlog, i, n) when i == n, do: backlog |> List.last()

  def solve(backlog, i, n) do
    IO.puts("i is #{i}")
    prev = backlog |> Enum.at(i - 1)

    elem =
      if backlog |> Enum.count(&(&1 == prev)) == 1,
        do: 0,
        else: i - rfind(backlog, prev)

    solve(backlog |> List.replace_at(i, elem), i + 1, n)
  end

  def part_two() do
    data = load_data()
    size = 30_000_000
    lst = List.duplicate(nil, size - length(data))
    solve(data ++ lst, length(data), size)
  end
end
