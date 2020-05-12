defmodule Forth do
  defstruct stack: [], builtin_words: %{}, custom_words: %{}

  @opaque evaluator :: %Forth{stack: [], builtin_words: %{}, custom_words: %{}}

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new(),
    do: %Forth{
      builtin_words: %{
        "+" => &sum/1,
        "-" => &subtract/1,
        "*" => &multiply/1,
        "/" => &divide/1,
        "dup" => &duplicate/1,
        "drop" => &drop/1,
        "swap" => &swap/1,
        "over" => &over/1
      }
    }

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t()) :: evaluator

  def eval(evaluator, s) do
    input = s |> prepare_input()
    evaluator |> do_eval(input)
  end

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t()
  def format_stack(%Forth{stack: stack}), do: stack |> Enum.reverse() |> Enum.join(" ")

  defp prepare_input(input),
    do:
      input
      |> String.replace(~r/[^\w:;+-\\*\/]| /, " ")
      |> String.downcase()
      |> String.split(" ", trim: true)

  defp do_eval(evaluator, []), do: evaluator

  defp do_eval(evaluator, [":", word | rest]) do
    case Integer.parse(word) do
      {_num, _rest} -> raise Forth.InvalidWord
      _ -> do_eval(evaluator, word, [], rest)
    end
  end

  defp do_eval(%Forth{custom_words: custom_words} = evaluator, [word | rest])
       when is_map_key(custom_words, word),
       do: do_eval(evaluator, custom_words[word] ++ rest)

  defp do_eval(%Forth{stack: stack, builtin_words: builtin_words} = evaluator, [word | rest])
       when is_map_key(builtin_words, word),
       do: do_eval(%Forth{evaluator | stack: builtin_words[word].(stack)}, rest)

  defp do_eval(%Forth{stack: stack} = evaluator, [number | rest]) do
    case Integer.parse(number) do
      {num, _rest} -> do_eval(%Forth{evaluator | stack: [num | stack]}, rest)
      _ -> raise Forth.UnknownWord
    end
  end

  defp do_eval(%Forth{custom_words: custom_words} = evaluator, word, operations, [";" | rest]),
    do:
      do_eval(
        %Forth{
          evaluator
          | custom_words: Map.put(custom_words, word, operations |> Enum.reverse())
        },
        rest
      )

  defp do_eval(evaluator, word, operations, [operation | rest]),
    do: do_eval(evaluator, word, [operation | operations], rest)

  defp subtract([x, y | rest]), do: [y - x | rest]
  defp sum([x, y | rest]), do: [x + y | rest]

  defp multiply([x, y | rest]), do: [x * y | rest]

  defp divide([0 | _rest]), do: raise(Forth.DivisionByZero)
  defp divide([x, y | rest]), do: [div(y, x) | rest]

  defp duplicate([]), do: raise(Forth.StackUnderflow)
  defp duplicate([head | _tail] = enumerable), do: [head | enumerable]

  defp drop([]), do: raise(Forth.StackUnderflow)
  defp drop([_head | tail]), do: tail

  defp swap([]), do: raise(Forth.StackUnderflow)
  defp swap([_n]), do: raise(Forth.StackUnderflow)
  defp swap([x, y | rest]), do: [y, x | rest]

  defp over([]), do: raise(Forth.StackUnderflow)
  defp over([_n]), do: raise(Forth.StackUnderflow)
  defp over([x, y | rest]), do: [y, x, y | rest]

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception word: nil
    def message(e), do: "invalid word: #{inspect(e.word)}"
  end

  defmodule UnknownWord do
    defexception word: nil
    def message(e), do: "unknown word: #{inspect(e.word)}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
