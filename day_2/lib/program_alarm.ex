defmodule Day2 do
  def get_input(file) do
    File.stream!(file)
    |> Stream.flat_map(&String.split(&1, ","))
    |> Enum.map(&String.to_integer(&1))
  end

  def op_code(program, operation) do
    case Enum.at(operation, 0) do
      1 ->
        IO.puts("Add")
        index = Enum.at(operation, 3)
        value = Enum.at(program, Enum.at(operation, 1)) + Enum.at(program, Enum.at(operation, 2))
        program = List.insert_at(program, index, value)
        Enum.each(program, &IO.puts(&1))

      # IO.puts(value)
      2 ->
        # program[operation[3]] = program[operation[1]] * program[operation[2]]
        IO.puts("Multiply")

      99 ->
        IO.puts("Finish")
    end
  end


  def compute(program, index) do
    IO.puts("Index: #{index}")
    operation = Enum.at(program, index)
    IO.puts("Operation: #{operation}")
    cond do
      operation == 99 -> hd program
        # IO.puts("Value at head:#{Enum.at(program, 0)}")
      operation ->
        x = Enum.at(program, index + 1) |> (&(Enum.at(program, &1))).()
        y = Enum.at(program, index + 2) |> (&(Enum.at(program, &1))).()
        position = Enum.at(program, index + 3) #|> (&(Enum.at(program, &1))).()
        IO.puts("#{x}:#{y} #{position}")
        case operation do
          1 -> List.replace_at(program, position, x + y)
          2 -> List.replace_at(program, position, x * y)
        end
    end
  end

  def computer(program) do
    Stream.unfold(0, fn
      x when x >= length(program) -> nil
      x -> {x, x + 4}
    end)
    |> Enum.reduce_while(program,
          fn x, acc ->
            if is_list(acc) do
              {:cont, compute(acc, x)}
            else
              {:halt, acc}
            end
          end)
  end

  def part_one do
    get_input("replaced_input")
    |> computer()
  end
end
