defmodule BinarySearchTree do
  @type bst_node :: %BinarySearchTree{data: any, left: bst_node | nil, right: bst_node | nil}
  defstruct data: nil, left: nil, right: nil

  @doc """
  Create a new Binary Search Tree with root's value as the given 'data'
  """
  @spec new(any) :: bst_node
  def new(data), do: %BinarySearchTree{data: data}

  @doc """
  Creates and inserts a node with its value as 'data' into the tree.
  """
  @spec insert(bst_node, any) :: bst_node
  def insert(nil, data), do: new(data)

  def insert(%BinarySearchTree{data: cur_data, left: left} = bst_node, data)
      when data <= cur_data,
      do: %BinarySearchTree{bst_node | left: insert(left, data)}

  def insert(%BinarySearchTree{data: cur_data, right: right} = bst_node, data)
      when data > cur_data,
      do: %BinarySearchTree{bst_node | right: insert(right, data)}

  @doc """
  Traverses the Binary Search Tree in order and returns a list of each node's data.
  """
  @spec in_order(bst_node) :: [any]
  def in_order(tree), do: [] |> do_in_order(tree) |> Enum.reverse()

  defp do_in_order(acc, nil), do: acc

  defp do_in_order(acc, %BinarySearchTree{data: data, left: left, right: right}),
    do:
      acc
      |> do_in_order(left)
      |> List.insert_at(0, data)
      |> do_in_order(right)
end
