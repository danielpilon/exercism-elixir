defmodule CustomSet do
  @empty_map %{}

  @opaque t :: %CustomSet{map: map}

  defstruct map: @empty_map

  @spec new(Enum.t()) :: t
  def new(enumerable), do: %CustomSet{map: Enum.into(enumerable, @empty_map, &{&1, true})}

  @spec empty?(t) :: boolean
  def empty?(%CustomSet{map: map}), do: map |> Map.equal?(@empty_map)

  @spec contains?(t, any) :: boolean
  def contains?(%CustomSet{map: map}, element), do: map |> Map.has_key?(element)

  @spec subset?(t, t) :: boolean
  def subset?(%CustomSet{map: map}, custom_set_2),
    do: map |> Map.keys() |> Enum.all?(&contains?(custom_set_2, &1))

  @spec disjoint?(t, t) :: boolean
  def disjoint?(%CustomSet{map: map}, custom_set_2),
    do: map |> Map.keys() |> Enum.any?(&contains?(custom_set_2, &1)) |> Kernel.not()

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2), do: custom_set_1 == custom_set_2

  @spec add(t, any) :: t
  def add(%CustomSet{map: map} = custom_set, element),
    do: %{custom_set | map: map |> Map.put(element, true)}

  @spec intersection(t, t) :: t
  def intersection(%CustomSet{map: map_1}, %CustomSet{map: map_2}),
    do: %CustomSet{map: map_2 |> Map.take(map_1 |> Map.keys())}

  @spec difference(t, t) :: t
  def difference(%CustomSet{map: map_1}, %CustomSet{map: map_2}),
    do: %CustomSet{map: map_1 |> Map.drop(map_2 |> Map.keys())}

  @spec union(t, t) :: t
  def union(%CustomSet{map: map_1}, %CustomSet{map: map_2}),
    do: %CustomSet{map: map_1 |> Map.merge(map_2)}
end
