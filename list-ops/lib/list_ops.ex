defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l), do: count(l, 0)

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l, [])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: map(l, f, [])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter(l, f, [])

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([head | tail], acc, f), do: reduce(tail, f.(head, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: append(a, b, [])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: concat(ll, [])

  defp count([], cur), do: cur
  defp count([_ | tail], cur), do: count(tail, cur + 1)

  defp reverse([], acc), do: acc
  defp reverse([head | tail], acc), do: reverse(tail, [head | acc])

  defp map([], _, acc), do: acc |> reverse()
  defp map([head | tail], f, acc), do: map(tail, f, [f.(head) | acc])

  defp filter([], _, acc), do: acc |> reverse()

  defp filter([head | tail], f, acc) do
    case f.(head) do
      true -> filter(tail, f, [head | acc])
      false -> filter(tail, f, acc)
    end
  end

  defp append([], [], acc), do: acc |> reverse()
  defp append([], [head | tail], acc), do: append([], tail, [head | acc])
  defp append([head | tail], b, acc), do: append(tail, b, [head | acc])

  defp concat([], acc), do: acc |> reverse()
  defp concat([[] | tail], acc), do: concat(tail, acc)

  defp concat([[head | element_tail] | tail], acc),
    do: concat([element_tail | tail], [head | acc])
end
