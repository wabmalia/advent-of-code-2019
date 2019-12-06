defmodule Day3 do
  def get_input(file) do
    File.stream!(file)
    |> Stream.map(&String.split(String.trim(&1), ","))
    |> Enum.map(fn wire -> to_coordinates(wire) end)
  end

  def to_coordinates(wire) do
    Enum.reduce(wire, [{0, 0}], fn action, acc ->
      acc ++ [to_coordinate(action, List.last(acc))]
    end)
  end

  defp to_coordinate("U" <> number, {x, y}), do: {x, y + String.to_integer(number)}
  defp to_coordinate("D" <> number, {x, y}), do: {x, y - String.to_integer(number)}
  defp to_coordinate("R" <> number, {x, y}), do: {x + String.to_integer(number), y}
  defp to_coordinate("L" <> number, {x, y}), do: {x - String.to_integer(number), y}

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

  def find_intersection([wire_a, wire_b]) do
    acc_intersection = fn {crossed, {x, y}} ->
      if crossed && x + y > 0 do
        [{x, y}]
      else
        []
      end
    end

    compare_segment = fn segment_a ->
      fn segment_b ->
        crossing_point(segment_a, segment_b)
        |> acc_intersection.()
      end
    end

    trace_wire(wire_a, fn segment -> [segment] end)
    |> Enum.flat_map(fn segment -> trace_wire(wire_b, compare_segment.(segment)) end)
  end

  def vector_distance({x_a, y_a}, {x_b, y_b}) do
    floor(:math.sqrt(:math.pow(x_b - x_a, 2) + :math.pow(y_b - y_a, 2)))
  end

  def calculate_distance([head | tail], point, acc \\ 0) do
    if length(tail) == 0 do
      acc
    else
      case crossing_point({head, hd(tail)}, {point, point}) do
        {crossed, intersection} when crossed ->
          acc + vector_distance(head, intersection)

        {false, _} ->
          calculate_distance(tail, point, acc + vector_distance(head, hd(tail)))
      end
    end
  end

  def part_one do
    get_input("input")
    |> find_intersection()
    |> Stream.map(fn {x, y} -> x + y end)
    |> Enum.min()
  end

  def part_two do
    [wire_a, wire_b] = get_input("input")

    find_intersection([wire_a, wire_b])
    |> Enum.map(&(calculate_distance(wire_a, &1) + calculate_distance(wire_b, &1)))
    |> Enum.min()
  end
end
