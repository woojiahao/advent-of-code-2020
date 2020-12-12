defmodule Solution do
  @directions [:N, :E, :S, :W]
  @ship_pos %{
    facing: 1,
    north: 0,
    south: 0,
    east: 0,
    west: 0
  }
  @waypoint_pos %{
    north: 0,
    south: 0,
    east: 0,
    west: 0
  }

  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/^([NSEWLRF])(\d+)$/, &1, capture: :all_but_first))
    |> Enum.map(fn [i, v] -> [String.to_atom(i), String.to_integer(v)] end)
  end

  defp move(dir, opp_dir, dist, pos) do
    opposing = min(pos[opp_dir], dist)
    remaining = dist - opposing

    pos
    |> Map.replace!(opp_dir, pos[opp_dir] - opposing)
    |> Map.replace!(dir, pos[dir] + remaining)
  end

  defp execute([:N, dist], pos), do: move(:north, :south, dist, pos)
  defp execute([:S, dist], pos), do: move(:south, :north, dist, pos)
  defp execute([:E, dist], pos), do: move(:east, :west, dist, pos)
  defp execute([:W, dist], pos), do: move(:west, :east, dist, pos)
  defp execute([:R, deg], pos), do: %{pos | facing: rem(div(deg, 90) + pos[:facing], 4)}
  defp execute([:L, deg], pos), do: %{pos | facing: rem(pos[:facing] - div(deg, 90) + 4, 4)}
  defp execute([:F, dist], pos), do: execute([@directions |> Enum.at(pos[:facing]), dist], pos)

  defp manhattan_distance(%{north: n, south: s, east: e, west: w}), do: abs(n - s) + abs(e - w)

  defp traverse([], pos), do: pos

  defp traverse(instructions, pos) do
    [instruction | rest] = instructions
    traverse(rest, execute(instruction, pos))
  end

  defp part_one() do
    load_data() |> traverse(@ship_pos) |> manhattan_distance()
  end

  defp execute!([:N, dist], {_, waypoint_pos}),
    do: move(:north, :south, dist, waypoint_pos)

  defp execute!([:S, dist], {_, waypoint_pos}),
    do: move(:south, :north, dist, waypoint_pos)

  defp execute!([:E, dist], {_, waypoint_pos}),
    do: move(:east, :west, dist, waypoint_pos)

  defp execute!([:W, dist], {_, waypoint_pos}),
    do: move(:west, :east, dist, waypoint_pos)

  defp execute!([:R, deg], {ship_pos, waypoint_pos}) do
    %{pos | facing: rem(div(deg, 90) + pos[:facing], 4)}
  end

  defp execute!([:L, deg], {ship_pos, waypoint_pos}),
    do: %{pos | facing: rem(pos[:facing] - div(deg, 90) + 4, 4)}

  defp execute!([:F, dist], {ship_pos, waypoint_pos}) do
    %{north: n, south: s, east: e, west: w} = waypoint_pos
    a = execute([:N, n * 100], ship_pos)
    b = execute([:E, e * 100], a)
    c = execute([:S, e * 100], b)
    d = execute([:W, e * 100], c)
    d
  end

  defp traverse!([], {ship_pos, _}), do: ship_pos

  defp traverse!(instructions, {ship_pos, waypoint_pos}) do
    [instruction | rest] = instructions
    traverse!(rest, execute!(instruction, {ship_pos, waypoint_pos}))
  end

  def part_two() do
    load_data() |> traverse!(@ship_pos, @waypoint_pos)
  end
end
