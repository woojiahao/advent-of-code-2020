defmodule Solution do
  @rule_regex ~r/^([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)$/

  defp load_data() do
    # TODO Read data from single file

    rules =
      File.read!("rules.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.run(@rule_regex, &1, capture: :all_but_first))
      |> Enum.flat_map(fn [_ | range] -> range |> Enum.map(&String.to_integer/1) end)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [lower, upper] -> lower..upper end)

    my_tickets =
      File.read!("my_tickets.txt")
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    nearby_tickets =
      File.read!("nearby_tickets.txt")
      |> String.split("\n", trim: true)
      |> List.flatten()
      |> Enum.flat_map(&String.split(&1, ",", trim: true))
      |> Enum.map(&String.to_integer/1)

    {rules, my_tickets, nearby_tickets}
  end

  defp part_one() do
    {rules, _, nearby_tickets} = load_data()

    nearby_tickets
    |> Enum.filter(fn no -> not (rules |> Enum.any?(&(no in &1))) end)
    |> Enum.sum()
  end

  defp load_data!() do
    # As the second part requires the original format of the data to preserved, we cannot flatten the data

    rules =
      File.read!("rules.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.run(@rule_regex, &1, capture: :all_but_first))
      |> Enum.map(fn [field | range] ->
        [field | range |> Enum.map(&String.to_integer/1) |> Enum.chunk_every(2)]
      end)
      |> Enum.map(fn [field | ranges] ->
        [field | ranges |> Enum.map(fn [lower, upper] -> lower..upper end)]
      end)

    rules_ranges = rules |> Enum.flat_map(fn [_ | ranges] -> ranges end)

    my_tickets =
      File.read!("my_tickets.txt")
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.split(",", trim: true)

    nearby_tickets =
      File.read!("nearby_tickets.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ",", trim: true))
      |> Enum.map(fn t -> t |> Enum.map(&String.to_integer/1) end)

    valid_tickets =
      nearby_tickets
      |> Enum.filter(fn t ->
        t
        |> Enum.all?(fn v ->
          rules_ranges |> Enum.any?(&(v in &1))
        end)
      end)

    {rules_ranges, my_tickets, valid_tickets}
  end

  defp get_column_fields([], _ranges, tracking), do: tracking

  defp get_column_fields([column | rest], ranges, tracking) do
    # For every column, find the rules that fit it
    potential_fields =
      column
      |> Enum.map(fn v ->
        ranges
        |> Enum.with_index()
        |> Enum.filter(fn {range, _j} ->
          range |> Enum.any?(&(v in &1))
        end)
        |> Enum.map(fn {_, j} -> j end)
        |> MapSet.new()
      end)

    # tracking is a sets problem where tracking and potential are both sets and the values to continue
    # tracking are the ones that are found in both the current tracking and latest potential
    tracking_updated =
      tracking
      |> Enum.zip(potential_fields)
      |> Enum.map(fn {track, potential} -> MapSet.intersection(track, potential) end)

    get_column_fields(rest, ranges, tracking_updated)
  end

  def part_two() do
    {rules_ranges, my_tickets, valid_tickets} = load_data!()

    # Generate the potential rule locations for each nearby_ticket
    # With all potential rule locations identified, simply get the most common rule among all and that's the rule for the column
    # Assume that each column can potentially be a field and eliminate the non-possible choices after looking at each valid ticket

    ranges = rules_ranges |> Enum.chunk_every(2)

    size = length(ranges)

    tracking =
      0..(size - 1)
      |> Enum.map(fn _ -> 0..(size - 1) |> MapSet.new() end)

    potential_column_fields =
      valid_tickets
      |> get_column_fields(ranges, tracking)
      |> Enum.with_index()
      |> Enum.sort(fn a, b -> MapSet.size(elem(a, 0)) < MapSet.size(elem(b, 0)) end)

    # With the potential column fields, we then start to assign the column's fields through a process of elimination
    # I.e. a pattern forms where one column has a definite field (1 potential value), then we find another column with
    # two potential values where one of these values is the field from the previous iteration and with this we can start
    # to get the differences in sets and find the column's fields

    # IMPORTANT: We must preserve the index of the column that each field is assigned to even when sorting to ensure
    # that we don't mis-assign the field to the column
    fields_partial =
      potential_column_fields
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] ->
        {elem(b, 0) |> MapSet.difference(elem(a, 0)), elem(b, 1)}
      end)

    fields =
      [potential_column_fields |> List.first() | fields_partial]
      |> Enum.map(fn {f, col} -> {col, f |> Enum.to_list() |> List.first()} end)
      |> Enum.sort(fn a, b -> elem(a, 1) < elem(b, 1) end)

    # Find the columns where the fields are the depature

    depature_indices =
      fields
      |> Enum.take(6)
      |> Enum.map(fn {col, _field} -> col end)

    my_tickets
    |> Enum.with_index()
    |> Enum.filter(fn {v, i} -> i in depature_indices end)
    |> Enum.map(fn {v, _} -> String.to_integer(v) end)
    |> List.foldl(1, fn x, acc -> x * acc end)
  end
end
