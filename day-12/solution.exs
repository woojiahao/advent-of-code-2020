defmodule Solution do
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
