defmodule Solution do
  use Agent

  defp load_data() do
    # We can assume that there are no duplicates
    data =
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    ([0] ++ data ++ [(data |> Enum.max()) + 3]) |> Enum.sort()
  end

  defp generate_tree(data) do
    data
    |> Enum.map(fn x ->
      {x, data |> Enum.filter(&((&1 - x) in 1..3))}
    end)
    |> Map.new()
  end

  defp traverse(_tree, start, last) when start == last, do: 1

  defp traverse(tree, start, last) do
    IO.puts("#{start} -> #{inspect(tree[start], charlists: :as_lists)}")
    cached_value = Agent.get(__MODULE__, &Map.get(&1, start))

    if cached_value do
      cached_value
    else
      paths =
        tree[start]
        |> Enum.map(&traverse(tree, &1, last))
        |> List.flatten()
        |> Enum.sum()

      Agent.update(__MODULE__, &Map.put(&1, start, paths))

      paths
    end
  end

  defp part_one() do
    %{1 => n, 3 => m} =
      load_data()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [x, y] -> y - x end)
      |> Enum.frequencies()

    n * m
  end

  def part_two() do
    # To solve this part, we can map the outcomes as a tree
    Agent.start_link(fn -> %{} end, name: __MODULE__)
    data = load_data()

    data
    |> generate_tree()
    |> traverse(0, data |> List.last())
  end
end
