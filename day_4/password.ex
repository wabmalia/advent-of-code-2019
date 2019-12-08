defmodule Password do
  def filter(password, condition, evaluation) do
    Integer.to_charlist(password)
    |> Enum.reduce_while({0, false, [0]}, &condition.(&1, &2))
    |> evaluation.()
  end
end

condition = fn (curr, {last, is_increasing, match_count}) ->
  [head | tail] = match_count
  cond do
    last == curr -> {:cont, {curr, is_increasing, [(head + 1)] ++ tail}}
    last < curr -> {:cont, {curr, true, [0] ++ match_count}}
    true -> {:halt, {curr, false, match_count}}
  end
end

evaluation_one = fn ({_, is_increasing, match_count}) ->
  is_increasing && Enum.any?(match_count, &(&1 > 0))
end

IO.inspect("Day 4")
IO.inspect("Part One:")

Stream.filter(153517..630395,
&Password.filter(&1, condition, evaluation_one))
|> Enum.count()
|> IO.inspect()

evaluation_two = fn ({_, is_increasing, match_count}) ->
  is_increasing && Enum.any?(match_count, fn x -> x == 1 end)
end

IO.inspect("Part Two:")

Stream.filter(153517..630395,
  &Password.filter(&1, condition, evaluation_two))
|> Enum.count()
|> IO.inspect()



