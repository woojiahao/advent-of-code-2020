defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n", trim: true)

  defp compute_pos(<<head::binary-size(1), rest::binary>>, lower, upper) when rest == "" do
    cond do
      head in ["F", "L"] -> lower
      true -> upper
    end
  end

  defp compute_pos(<<head::binary-size(1), rest::binary>>, lower, upper) do
    d = div(upper - lower, 2)

    cond do
      head in ["F", "L"] -> compute_pos(rest, lower, upper - d - 1)
      true -> compute_pos(rest, lower + d + 1, upper)
    end
  end

  defp compute_seat_id(<<rows::binary-size(7), cols::binary-size(3)>>) do
    compute_pos(rows, 0, 127) * 8 + compute_pos(cols, 0, 7)
  end

  defp seat_ids(), do: @data |> Enum.map(&compute_seat_id/1)

  def part_one(), do: seat_ids() |> Enum.max()

  def part_two() do
    missing_seats = Enum.to_list(0..(127 * 8 + 8)) -- seat_ids()
    missing_seats
  end
end
