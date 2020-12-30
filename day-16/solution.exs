defmodule Solution do
  defp load_data() do
    # TODO Read data from single file
    rule_regex = ~r/^([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)$/

    rules =
      File.read!("rules.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&Regex.run(rule_regex, &1, capture: :all_but_first))
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

  def part_one() do
    {rules, _, nearby_tickets} = load_data()

    nearby_tickets
    |> Enum.filter(fn no -> not (rules |> Enum.any?(&(no in &1))) end)
    |> Enum.sum()
  end
end
