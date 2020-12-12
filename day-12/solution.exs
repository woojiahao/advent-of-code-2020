defmodule PartOne do
  @directions [:N, :E, :S, :W]

  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/^([NSEWLRF])(\d+)$/, &1, capture: :all_but_first))
    |> Enum.map(fn [i, v] -> [String.to_atom(i), String.to_integer(v)] end)
  end

  defp execute([:N, dist], f, x, y), do: {f, x, y + dist}
  defp execute([:S, dist], f, x, y), do: {f, x, y - dist}
  defp execute([:E, dist], f, x, y), do: {f, x + dist, y}
  defp execute([:W, dist], f, x, y), do: {f, x - dist, y}
  defp execute([:R, deg], f, x, y), do: {rem(f + div(deg, 90), 4), x, y}
  defp execute([:L, deg], f, x, y), do: {rem(abs(f - div(deg, 90) + 4), 4), x, y}
  defp execute([:F, dist], f, x, y), do: execute([@directions |> Enum.at(f), dist], f, x, y)

  defp solve([], _f, x, y), do: abs(x) + abs(y)

  defp solve(instructions, f, x, y) do
    [instruction | rest] = instructions
    IO.puts("instruction #{inspect(instruction)} -> f #{f}, x #{x}, y #{y}")
    {f!, x!, y!} = execute(instruction, f, x, y)
    solve(rest, f!, x!, y!)
  end

  def part_one() do
    load_data() |> solve(1, 0, 0)
  end
end

defmodule PartTwo do
  @directions [:N, :E, :S, :W]

  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/^([NSEWLRF])(\d+)$/, &1, capture: :all_but_first))
    |> Enum.map(fn [i, v] -> [String.to_atom(i), String.to_integer(v)] end)
  end

  defp execute([:N, dist], f, sx, sy, wx, wy), do: {f, sx, sy, wx, wy + dist}
  defp execute([:S, dist], f, sx, sy, wx, wy), do: {f, sx, sy, wx, wy - dist}
  defp execute([:E, dist], f, sx, sy, wx, wy), do: {f, sx, sy, wx + dist, wy}
  defp execute([:W, dist], f, sx, sy, wx, wy), do: {f, sx, sy, wx - dist, wy}

  defp execute([:R, deg], f, sx, sy, wx, wy) do
    moves = [wx, wy, -wx, -wy]
    shift_x = moves |> Enum.at(rem(div(deg, 90), 4))
    shift_y = moves |> Enum.at(rem(div(deg, 90) + 1, 4))

    {f, sx, sy, shift_x, shift_y}
  end

  defp execute([:L, deg], f, sx, sy, wx, wy) do
    moves = [wx, wy, -wx, -wy]
    shift_x = moves |> Enum.at(rem(4 - div(deg, 90), 4))
    shift_y = moves |> Enum.at(rem(4 - div(deg, 90) + 1, 4))

    {f, sx, sy, shift_x, shift_y}
  end

  defp execute([:F, factor], f, sx, sy, wx, wy) do
    f_wx = wx * factor
    f_wy = wy * factor
    {f, sx + f_wx, sy + f_wy, wx, wy}
  end

  defp solve([], _f, sx, sy, _wx, _wy), do: abs(sx) + abs(sy)

  defp solve(instructions, f, sx, sy, wx, wy) do
    [instruction | rest] = instructions

    IO.puts(
      "instruction #{inspect(instruction)} -> f #{f}, sx #{sx}, sy #{sy}, wx #{wx}, wy #{wy}"
    )

    {f!, sx!, sy!, wx!, wy!} = execute(instruction, f, sx, sy, wx, wy)
    solve(rest, f!, sx!, sy!, wx!, wy!)
  end

  def part_two() do
    load_data() |> solve(1, 0, 0, 10, 1)
  end
end
