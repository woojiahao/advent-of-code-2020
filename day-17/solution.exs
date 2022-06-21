defmodule Solution do
  defp load_data(),
    do:
      File.read!("data.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

  def part_one() do
  end
end
