defmodule Solution do
  defp load_data() do
    File.read!("data.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " = ", trim: true))
    |> Enum.map(&parse_instruction/1)
  end

  defp pad(list, size, pad_value) do
    leading = List.duplicate(pad_value, size - length(list))
    leading ++ list
  end

  defp parse_instruction(["mask", v]), do: {:mask, v |> String.split("", trim: true)}

  defp parse_instruction([<<i::binary-size(3), rest::binary>>, x]) when i == "mem" do
    addr =
      Regex.run(~r/^\[(\d+)\]$/, rest, capture: :all_but_first)
      |> List.first()
      |> String.to_integer()

    value = x |> String.to_integer() |> Integer.digits(2)

    {:mem, {addr, pad(value, 36, 0)}}
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

  defp execute([], _mask, memory),
    do:
      memory
      |> Map.values()
      |> Enum.map(&Integer.undigits(&1, 2))
      |> Enum.sum()

  defp execute([instruction | rest], mask, memory) do
    {m, mem} = run(instruction, mask, memory)
    execute(rest, m, mem)
  end

  defp part_one() do
    load_data() |> execute(List.duplicate("X", 36), %{})
  end

  defp apply_mask!(value, mask) do
    0..35
    |> Enum.map(fn i ->
      m = mask |> Enum.at(i)

      case m do
        "0" -> value |> Enum.at(i) |> Integer.to_string()
        _ -> m
      end
    end)
  end

  # Update the mask
  defp run!({:mask, m}, _mask, memory), do: {m, memory}

  # Generate the memory addresses that will receive the new value from the current mask
  defp run!({:mem, {i, v}}, mask, memory) do
    addr = i |> Integer.digits(2) |> pad(36, 0) |> apply_mask!(mask)
    val = v |> Integer.undigits(2)

    floating_indices =
      addr
      |> Stream.with_index()
      |> Enum.filter(&(elem(&1, 0) == "X"))
      |> Enum.map(&elem(&1, 1))

    bit_perms =
      0..trunc(:math.pow(2, length(floating_indices)) - 1)
      |> Enum.map(&pad(Integer.digits(&1, 2), length(floating_indices), 0))
      |> Enum.map(fn perm ->
        0..(length(floating_indices) - 1)
        |> Enum.map(fn i ->
          {Enum.at(floating_indices, i), Enum.at(perm, i)}
        end)
        |> Map.new()
      end)

    target_addrs =
      bit_perms
      |> Enum.map(fn perm ->
        addr
        |> Stream.with_index()
        |> Enum.map(fn {a, i} ->
          if Map.has_key?(perm, i), do: perm[i] |> Integer.to_string(), else: a
        end)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&Integer.undigits(&1, 2))

    target_mem =
      target_addrs
      |> Enum.zip(List.duplicate(val, length(target_addrs)))
      |> Map.new()

    updated_mem = memory |> Map.merge(target_mem)
    {mask, updated_mem}
  end

  defp execute!([], _mask, memory), do: memory |> Map.values() |> Enum.sum()

  defp execute!([instruction | rest], mask, memory) do
    {m, mem} = run!(instruction, mask, memory)
    execute!(rest, m, mem)
  end

  def part_two() do
    load_data() |> execute!(List.duplicate("0", 36), %{})
  end
end
