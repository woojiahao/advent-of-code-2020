defmodule Solution do
  @data File.read!("data.txt") |> String.split("\n", trim: true)

  defp compute_pos(<<head::binary-size(1), rest::binary>>, lower, upper) when rest == "" do
    if head in ["F", "L"], do: lower, else: upper
  end

  defp compute_pos(<<head::binary-size(1), rest::binary>>, lower, upper) do
    d = div(upper - lower, 2)

    if head in ["F", "L"],
      do: compute_pos(rest, lower, upper - d - 1),
      else: compute_pos(rest, lower + d + 1, upper)
  end

  defp compute_seat_id(<<rows::binary-size(7), cols::binary-size(3)>>) do
    compute_pos(rows, 0, 127) * 8 + compute_pos(cols, 0, 7)
  end

  defp seat_ids(), do: @data |> Enum.map(&compute_seat_id/1)

  def part_one(), do: seat_ids() |> Enum.max()

  def part_two() do
    # Your seat is the missing seat between two booked seats
    # Go through all missing seats and check if the surrounding seats are booked
    missing_seats = Enum.to_list(0..(127 * 8 + 8)) -- seat_ids()

    missing_seats
    |> Enum.filter(&((&1 - 1) in seat_ids() and (&1 + 1) in seat_ids()))
    |> List.first()
  end

  def print_seats() do
    for row <- 0..127 do
      for col <- 0..7 do
        if (row * 8 + col) in seat_ids() do
          IO.write("X")
        else
          IO.write("O")
        end
      end

      IO.puts("")
    end
  end
end
