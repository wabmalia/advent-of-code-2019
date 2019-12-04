defmodule Day2 do
  def get_input(file) do
    File.stream!(file)
    |> Stream.flat_map(&String.split(&1, ","))
    |> Enum.map(&String.to_integer(&1))
  end

  def execute(index, program) do
    # IO.puts("Index: #{index}")
    operation = Enum.at(program, index)
    # IO.puts("Operation: #{operation}")
    cond do
      operation == 99 ->
        {:halt, program}

      operation ->
        x = Enum.at(program, index + 1) |> (&Enum.at(program, &1)).()
        y = Enum.at(program, index + 2) |> (&Enum.at(program, &1)).()
        position = Enum.at(program, index + 3)
        # IO.puts("#{x}_#{y}_#{position}")
        case operation do
          1 -> {:cont, List.replace_at(program, position, x + y)}
          2 -> {:cont, List.replace_at(program, position, x * y)}
        end
    end
  end

  def computer(program) do
    Stream.unfold(0, fn x -> {x, x + 4} end)
    |> Enum.reduce_while(program, fn x, acc -> execute(x, acc) end)
    |> hd
  end

  def replace_noun_and_verb(program, [noun, verb]) do
    program
    |> (fn p -> List.replace_at(p, 1, noun) end).()
    |> (fn p -> List.replace_at(p, 2, verb) end).()
  end

  def extract_noun_and_verb([_, noun, verb | _]) do
    noun * 100 + verb
  end

  def find_noun_and_verb(program) do
    Stream.map(0..9999, fn r -> [div(r, 100), rem(r, 100)] end)
    |> Stream.map(fn x -> replace_noun_and_verb(program, x) end)
    |> Enum.find(fn x -> computer(x) == 19_690_720 end)
    |> extract_noun_and_verb()
  end

  def part_one do
    get_input("replaced_input")
    |> computer()
  end

  def part_two do
    get_input("input")
    |> find_noun_and_verb()
  end
end
