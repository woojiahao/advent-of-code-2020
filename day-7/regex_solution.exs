defmodule RegexSolution do
  defp load_data() do
    # TODO Use adjacency lists
    pattern = ~r/^([\w\s]+) bags contain ([\w\d\s,]+).$/

    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(pattern, &1, capture: :all_but_first))
    |> Enum.map(fn [name, body] ->
      [name | String.split(body, ~r{(bags(,)*|bag(,)*)}, trim: true)]
    end)
    |> Enum.map(fn [name | body] ->
      [
        name
        | [
            body
            |> Enum.map(&Regex.run(~r/(\d+) ([\w\s]+)/, &1, capture: :all_but_first))
          ]
      ]
    end)
    |> Map.new(fn [name, body] -> {name, body} end)
    |> Map.new(fn {key, value} ->
      if value |> List.first() == nil do
        {key, nil}
      else
        {key,
         value
         |> Map.new(fn [quantity, name] ->
           {String.trim(name), String.to_integer(quantity)}
         end)}
      end
    end)
  end

  defp search(bags, target, searched \\ []) do
    # Search propagates upwards till no other searches are found
    IO.puts("target #{target}, searched #{inspect(searched)}")

    parents =
      bags
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.filter(fn {_, v} -> Map.has_key?(v, target) end)
      |> Enum.map(fn {k, _} -> k end)

    if length(parents) == 0 do
      searched
    else
      parents
      |> Enum.map(&search(bags, &1, [searched | parents] |> List.flatten()))
      |> List.flatten()
      |> Enum.uniq()
    end
  end

  def part_one() do
    load_data() |> search("shiny gold") |> length()
  end
end
