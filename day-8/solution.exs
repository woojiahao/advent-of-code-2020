defmodule Solution do
  defp load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "\s", trim: true))
      |> Enum.map(fn [op, arg] -> [op, String.to_integer(arg)] end)

  defp execute(instructions, acc \\ 0, pos \\ 0, ran \\ []) do
    cond do
      pos in ran ->
        {acc, :inf_loop}

      pos == length(instructions) ->
        {acc, :end}

      true ->
        [op, arg] = instructions |> Enum.at(pos)

        case op do
          "acc" -> execute(instructions, acc + arg, pos + 1, ran ++ [pos])
          "jmp" -> execute(instructions, acc, pos + arg, ran ++ [pos])
          "nop" -> execute(instructions, acc, pos + 1, ran ++ [pos])
          _ -> raise "Invalid operation code #{op} found."
        end
    end
  end

  def part_one() do
    load_data() |> execute()
  end

  def part_two() do
    data = load_data()

    # Generate all variations of the instruction sets
    variations =
      data
      |> Stream.with_index()
      |> Enum.filter(fn {[op, _], _} -> op in ~w(jmp nop) end)
      |> Enum.map(fn {_, i} ->
        [op, arg] = Enum.at(data, i)

        case op do
          "jmp" -> data |> List.replace_at(i, ["nop", arg])
          "nop" -> data |> List.replace_at(i, ["jmp", arg])
          _ -> true
        end
      end)

    variations
    |> Enum.map(&execute(&1))
    |> Enum.filter(fn {acc, r} -> r == :end end)
  end
end
