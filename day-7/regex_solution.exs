defmodule RegexSolution do
  defp load_data() do
    # TODO Create a parser for the syntax
    # TODO Use adjacency lists

    # TODO Use Regex.split instead of matching the pattern for easier time
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

  defp search_parents(bags, target, searched \\ []) do
    # Search propagates upwards till no other searches are found
    parents =
      bags
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.filter(fn {_, v} -> Map.has_key?(v, target) end)
      |> Enum.map(fn {k, _} -> k end)

    case length(parents) do
      0 ->
        searched

      _ ->
        parents
        |> Enum.map(&search_parents(bags, &1, [searched | parents] |> List.flatten()))
        |> List.flatten()
        |> Enum.uniq()
    end
  end

  defp search_children(bags, target) do
    case bags[target] do
      nil ->
        # If the current bag contains no other bags
        1

      _ ->
        # If the current bag contains some other bags
        # Get the list of bags they contain
        # Drill down to the last bag and get the total of the bags
        children =
          bags[target]
          |> Enum.map(fn {b, q} -> List.duplicate(b, q) end)
          |> List.flatten()

        1 + (children |> Enum.map(&search_children(bags, &1)) |> Enum.sum())
    end
  end

  def part_one() do
    load_data() |> search_parents("shiny gold") |> length()
  end

  def part_two() do
    (load_data() |> search_children("shiny gold")) - 1
  end
end
