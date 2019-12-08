defmodule Password do
  def condition(curr, {last, has_doubles, is_increasing}) do
    cond do
      last == curr -> {:cont, {curr, true, is_increasing}}
      last < curr -> {:cont, {curr, has_doubles, true}}
      true -> {:halt, {curr, false, false}}
    end
  end

  def filter(password) do
    Integer.to_charlist(password)
    |> Enum.reduce_while({0, false, false}, &condition(&1, &2))
    |> (fn {_, has_doubles, is_increasing} -> is_increasing && has_doubles end).()
  end
end

Stream.filter(153517..630395, &Password.filter(&1))
|> Enum.count()
|> IO.inspect()

