defmodule Day3 do
  def get_input(file) do
    File.stream!(file)
    |> Stream.map(&String.split(String.trim(&1), ","))
    |> Enum.map(fn entry -> to_move(entry) end)
    # |> Enum.map(&to_move(&1))
  end

  def to_move(entry) do
    Enum.map(entry,
      &({
        String.first(&1),
        String.slice(&1, 1..-1) |> String.to_integer()
      })
    )
  end

  def is_crossing(line_a, line_b) do

  end

  def is_segment_crossing(wire, segment) do

  end

  def is_wires_crossing([wire_a, wire_b]) do
    Enum.reduce(0.., acc, fun)
  end

  def part_one do
    get_input("input")
  end
end
