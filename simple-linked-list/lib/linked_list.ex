defmodule LinkedList do
  @opaque t :: tuple()

  @empty_list {:error, :empty_list}

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new(), do: {}

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem), do: {elem, list}

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(list), do: do_length(list, 0)

  @doc """
  Determine if a LinkedList is empty
  """

  @spec empty?(t) :: boolean()
  def empty?({}), do: true
  def empty?(_list), do: false

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: @empty_list
  def peek({head, _rest}), do: {:ok, head}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: @empty_list
  def tail({_head, tail}), do: {:ok, tail}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: @empty_list
  def pop({head, tail}), do: {:ok, head, tail}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list), do: list |> Enum.reverse() |> Enum.reduce(new(), &push(&2, &1))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list), do: do_to_list(list, []) |> Enum.reverse()

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list), do: do_reverse(list, {})

  defp do_reverse({}, acc), do: acc
  defp do_reverse({head, tail}, acc), do: do_reverse(tail, push(acc, head))

  defp do_length({}, acc), do: acc
  defp do_length({_head}, acc), do: acc + 1
  defp do_length({_head, rest}, acc), do: do_length(rest, acc + 1)

  defp do_to_list({}, acc), do: acc
  defp do_to_list({head, tail}, acc), do: do_to_list(tail, [head | acc])
end
