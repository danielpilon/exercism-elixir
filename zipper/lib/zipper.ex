defmodule Zipper do
  @type t :: %Zipper{focus: BinTree.t(), path: [{:left | :right, BinTree.t()}]}

  defstruct focus: %BinTree{}, path: []

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(bin_tree), do: %Zipper{focus: bin_tree}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree(%{focus: focus, path: []}), do: focus
  def to_tree(zipper), do: zipper |> up() |> to_tree()

  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value(%{focus: %{value: value}}), do: value

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left(%{focus: %{left: nil}, path: path}), do: nil

  def left(%{focus: %{left: left} = zipper, path: path}),
    do: %Zipper{focus: left, path: [{:left, zipper} | path]}

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right(%{focus: %{right: nil}, path: path}), do: nil

  def right(%{focus: %{right: right} = zipper, path: path}),
    do: %Zipper{focus: right, path: [{:right, zipper} | path]}

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up(%{path: []}), do: nil

  def up(%{focus: focus, path: [{:left, top} | rest]}),
    do: %Zipper{focus: %BinTree{top | left: focus}, path: rest}

  def up(%{focus: focus, path: [{:right, top} | rest]}),
    do: %Zipper{focus: %BinTree{top | right: focus}, path: rest}

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value(%{focus: focus} = zipper, value),
    do: %Zipper{zipper | focus: %{focus | value: value}}

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left(%{focus: focus} = zipper, left),
    do: %Zipper{zipper | focus: %BinTree{focus | left: left}}

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right(%{focus: focus} = zipper, right),
    do: %Zipper{zipper | focus: %BinTree{focus | right: right}}
end
