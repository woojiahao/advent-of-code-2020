defmodule Solution do
  defp load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

  defp at(_m, r, c) when r < 0 or c < 0, do: nil
  defp at(m, r, c), do: m |> Enum.at(r, []) |> Enum.at(c)

  defp size(m), do: [m |> length(), m |> Enum.at(0) |> length()]

  defp new(struct) do
    struct
    |> Enum.group_by(fn {[x, _], _} -> x end)
    |> Map.values()
    |> Enum.map(&Enum.map(&1, fn {_, s} -> s end))
  end

  defp adjacent(m, r, c) do
    movements = [
      [r, c - 1],
      [r, c + 1],
      [r - 1, c],
      [r + 1, c],
      [r - 1, c - 1],
      [r - 1, c + 1],
      [r + 1, c - 1],
      [r + 1, c + 1]
    ]

    movements
    |> Enum.map(fn [x, y] -> at(m, x, y) end)
    |> Enum.filter(&(&1 != nil and &1 != "."))
  end

  defp mutate(data) do
    [n_rows, n_cols] = data |> size()

    struct =
      for r <- 0..(n_rows - 1),
          c <- 0..(n_cols - 1) do
        occupied = data |> adjacent(r, c) |> Enum.filter(&(&1 == "#")) |> length()

        cur = data |> at(r, c)

        cond do
          cur == "L" and occupied == 0 -> {[r, c], "#"}
          cur == "#" and occupied >= 4 -> {[r, c], "L"}
          true -> {[r, c], cur}
        end
      end

    struct |> new()
  end

  defp loop(data, prev \\ []) do
    cur = data |> mutate()

    cond do
      cur == prev -> prev
      true -> cur |> loop(cur)
    end
  end

  def part_one() do
    load_data()
    |> loop()
    |> Enum.map(&Enum.count(&1, fn x -> x == "#" end))
    |> List.flatten()
    |> Enum.sum()
  end
end
