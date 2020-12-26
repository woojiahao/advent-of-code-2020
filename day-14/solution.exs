defmodule Solution do
  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " = ", trim: true))
    |> Enum.map(&parse_instruction/1)
  end

  defp parse_instruction(["mask", v]), do: {:mask, v |> String.split("", trim: true)}

  defp parse_instruction([<<i::binary-size(3), rest::binary>>, x]) when i == "mem" do
    addr =
      Regex.run(~r/^\[(\d+)\]$/, rest, capture: :all_but_first)
      |> List.first()
      |> String.to_integer()

    value = x |> String.to_integer() |> Integer.digits(2)
    leading = List.duplicate(0, 36 - length(value))

    {:mem, {addr, leading ++ value}}
  end

  defp parse_instruction(_), do: raise("Invalid instruction")

  defp apply_mask(mask, value) do
    0..35
    |> Enum.map(fn i ->
      m = mask |> Enum.at(i)
      if m != "X", do: m |> String.to_integer(), else: value |> Enum.at(i)
    end)
  end

  defp run({:mask, m}, _mask, memory), do: {m, memory}

  defp run({:mem, {i, v}}, mask, memory) do
    key = i |> Integer.to_string() |> String.to_atom()
    updated_memory = apply_mask(mask, v)
    {mask, Map.update(memory, key, updated_memory, fn _ -> updated_memory end)}
  end

  defp execute(instructions, _mask, memory) when length(instructions) == 0,
    do:
      memory
      |> Map.values()
      |> Enum.map(&Integer.undigits(&1, 2))
      |> Enum.sum()

  defp execute(instructions, mask, memory) do
    [instruction | rest] = instructions
    {m, mem} = run(instruction, mask, memory)
    execute(rest, m, mem)
  end

  def part_one() do
    load_data() |> execute(List.duplicate("X", 36), %{})
  end
end
