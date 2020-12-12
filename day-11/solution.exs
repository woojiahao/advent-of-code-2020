defmodule Solution do
  defp load_data() do
    data =
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    [n_rows, n_cols] = [data |> length(), data |> Enum.at(0) |> length()]
    pos = for r <- 0..(n_rows - 1), c <- 0..(n_cols - 1), do: [r, c]
    pos |> Enum.zip(data |> List.flatten()) |> Map.new()
  end

  defp print(m) do
    matrix =
      m
      |> Enum.group_by(fn {[x, _], _} -> x end)
      |> Enum.map(fn {_, pts} -> pts |> Enum.sort_by(fn {[_, y], _} -> y end) end)
      |> Enum.map(&Enum.map(&1, fn {_, s} -> s end))

    IO.puts(inspect(matrix, charlists: :as_lists, pretty: true, limit: :infinity))
  end

  defp at(_m, r, c) when r < 0 or c < 0, do: nil
  defp at(m, r, c), do: m |> Map.get([r, c])

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
    |> Enum.map(&Map.get(m, &1))
    |> Enum.filter(&(&1 != nil and &1 != "."))
  end

  defp sight_line!(m, r, c, pts, direction) do
    if [r, c] not in (m |> Map.keys()) do
      pts |> Enum.reverse() |> tl() |> Enum.reverse()
    else
      case direction do
        :dul -> sight_line!(m, r - 1, c - 1, pts ++ [[r - 1, c - 1]], :dul)
        :dur -> sight_line!(m, r - 1, c + 1, pts ++ [[r - 1, c + 1]], :dur)
        :ddl -> sight_line!(m, r + 1, c - 1, pts ++ [[r + 1, c - 1]], :ddl)
        :ddr -> sight_line!(m, r + 1, c + 1, pts ++ [[r + 1, c + 1]], :ddr)
        :up -> sight_line!(m, r - 1, c, pts ++ [[r - 1, c]], :up)
        :down -> sight_line!(m, r + 1, c, pts ++ [[r + 1, c]], :down)
        :left -> sight_line!(m, r, c - 1, pts ++ [[r, c - 1]], :left)
        :right -> sight_line!(m, r, c + 1, pts ++ [[r, c + 1]], :right)
        _ -> raise "Invalid direction"
      end
    end
  end

  defp adjacent!(m, r, c) do
    coords = m |> Enum.filter(&(elem(&1, 1) != "."))

    up =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> r! < r and c! == c end)
      |> Enum.max_by(fn {[r!, _c!], _s} -> r! end, fn -> nil end)

    down =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> r! > r and c! == c end)
      |> Enum.min_by(fn {[r!, _c!], _s} -> r! end, fn -> nil end)

    left =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> c! < c and r! == r end)
      |> Enum.max_by(fn {[_r!, c!], _s} -> c! end, fn -> nil end)

    right =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> c! > c and r! == r end)
      |> Enum.min_by(fn {[_r!, c!], _s} -> c! end, fn -> nil end)

    dul =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> c - r == c! - r! and r! < r and c! < c end)
      |> Enum.max_by(fn {[_r!, c!], _s} -> c! end, fn -> nil end)

    dur =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> c + r == c! + r! and r! < r and c! > c end)
      |> Enum.min_by(fn {[_r!, c!], _s} -> c! end, fn -> nil end)

    ddl =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> c + r == c! + r! and r! > r and c! < c end)
      |> Enum.max_by(fn {[_r!, c!], _s} -> c! end, fn -> nil end)

    ddr =
      coords
      |> Stream.filter(fn {[r!, c!], _s} -> c - r == c! - r! and r! > r and c! > c end)
      |> Enum.min_by(fn {[_r!, c!], _s} -> c! end, fn -> nil end)

    [up, down, left, right, dul, dur, ddl, ddr]
    |> Enum.filter(&(&1 != nil))
    |> Enum.map(fn {_, s} -> s end)
  end

  defp mutate(data) do
    data
    |> Map.keys()
    |> Enum.map(fn [r, c] ->
      occupied = data |> adjacent(r, c) |> Enum.filter(&(&1 == "#")) |> length()

      cur = data |> at(r, c)

      cond do
        cur == "L" and occupied == 0 -> {[r, c], "#"}
        cur == "#" and occupied >= 4 -> {[r, c], "L"}
        true -> {[r, c], cur}
      end
    end)
    |> Map.new()
  end

  defp mutate!(data) do
    data
    |> Map.keys()
    |> Enum.map(fn [r, c] ->
      # IO.puts("(#{r}, #{c}) -> #{inspect(data |> adjacent!(r, c), charlists: :as_lists)}")
      occupied = data |> adjacent!(r, c) |> Enum.filter(&(&1 == "#")) |> length()

      cur = data |> at(r, c)

      cond do
        cur == "L" and occupied == 0 -> {[r, c], "#"}
        cur == "#" and occupied >= 5 -> {[r, c], "L"}
        true -> {[r, c], cur}
      end
    end)
    |> Map.new()
  end

  defp loop(data, prev \\ %{}) do
    cur = data |> mutate()

    cond do
      cur == prev -> prev
      true -> cur |> loop(cur)
    end
  end

  defp loop!(data, prev \\ %{}) do
    IO.puts("loop")
    cur = data |> mutate!()

    cond do
      cur == prev -> prev
      true -> cur |> loop!(cur)
    end
  end

  def part_one() do
    load_data()
    |> loop()
    |> Map.values()
    |> List.flatten()
    |> Enum.count(&(&1 == "#"))
  end

  def part_two() do
    load_data()
    |> loop!()
    |> Map.values()
    |> List.flatten()
    |> Enum.count(&(&1 == "#"))
  end
end
