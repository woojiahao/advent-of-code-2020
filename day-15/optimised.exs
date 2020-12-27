defmodule Optimised do
  # Instead of storing all the values computed, store the latest positions of each value to save complexity
  defp load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

  defp gen_positions(data), do: data |> Stream.with_index() |> Map.new()

  defp solve(d, _cur, i, n) when i == n, do: d |> Enum.max_by(fn {v, j} -> j end) |> elem(0)

  defp solve(d, cur, i, n) do
    next = if Map.has_key?(d, cur), do: i - d[cur], else: 0
    update = %{cur => i}
    solve(Map.merge(d, update), next, i + 1, n)
  end

  def part_two() do
    data = load_data()
    [last | rest] = data |> Enum.reverse()
    solve(gen_positions(rest |> Enum.reverse()), last, length(rest), 30_000_000)

    # solve(positions, {data |> List.last(), length(data) - 1}, 10)

    # [
    #   [0, 3, 6],
    #   [1, 3, 2],
    #   [2, 1, 3],
    #   [1, 2, 3],
    #   [2, 3, 1],
    #   [3, 2, 1],
    #   [3, 1, 2]
    # ]
    # |> Enum.map(fn d ->
    #   [last | rest] = d |> Enum.reverse()
    #   d! = rest |> Enum.reverse()
    #   solve(gen_positions(d!), last, length(d!), 2020)
    # end)
  end
end
