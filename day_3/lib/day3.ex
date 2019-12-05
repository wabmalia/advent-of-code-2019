defmodule Day3 do
  def get_input(file) do
    File.stream!(file)
    |> Stream.map(&String.split(String.trim(&1), ","))
    |> Enum.map(fn wire -> to_coordinates(wire) end)
  end

  def to_coordinates(wire) do
    Enum.reduce(wire, [{0, 0}], fn action, acc ->
      acc ++ [to_coordinate(List.last(acc), action)]
    end)
  end

  def to_coordinate({x, y}, action) do
    direction = action |> String.first()
    movement = action |> String.slice(1..-1) |> String.to_integer()

    case direction do
      "U" -> {x, y + movement}
      "D" -> {x, y - movement}
      "R" -> {x + movement, y}
      "L" -> {x - movement, y}
    end
  end

  def is_between(value, range_a, range_b) do
    value <= max(range_a, range_b) && value >= min(range_a, range_b)
  end

  def crossing_point({{x_a_1, y_a_1}, {x_a_2, y_a_2}}, {{x_b_1, y_b_1}, {x_b_2, y_b_2}}) do
    cond do
      x_a_1 == x_a_2 &&
        is_between(y_b_1, y_a_1, y_a_2) &&
          is_between(x_a_1, x_b_1, x_b_2) ->
        {true, {x_a_1, y_b_1}}

      y_a_1 == y_a_2 &&
        is_between(y_a_1, y_b_1, y_b_2) &&
          is_between(x_b_1, x_a_1, x_a_2) ->
        {true, {x_b_1, y_a_1}}

      true ->
        {false, {0, 0}}
    end
  end

  def trace_wire([head | tail], operation, acc \\ []) do
    if length(tail) == 0 do
      acc
    else
      trace_wire(tail, operation, acc ++ operation.({head, hd(tail)}))
    end
  end

  def is_wires_crossing([wire_a, wire_b]) do
    IO.inspect(wire_a)
    IO.inspect(wire_b)
    IO.inspect("-----")

    extract_segments = fn segment -> [segment] end

    manhattan_distance = fn {crossed, {x, y}} ->
      if crossed && x + y > 0 do
        [x + y]
      else
        []
      end
    end

    compare_segment = fn segment_a ->
      fn segment_b ->
        crossing_point(segment_a, segment_b)
        |> manhattan_distance.()
      end
    end

    trace_wire(wire_a, extract_segments)
    |> Enum.flat_map(fn segment -> trace_wire(wire_b, compare_segment.(segment)) end)
    |> Enum.min()
  end

  def part_one do
    get_input("input")
    |> is_wires_crossing()
  end
end
