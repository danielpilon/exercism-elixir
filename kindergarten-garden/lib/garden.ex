defmodule Garden do
  @cups %{
    "R" => :radishes,
    "C" => :clover,
    "G" => :grass,
    "V" => :violets
  }

  @students [
    :alice,
    :bob,
    :charlie,
    :david,
    :eve,
    :fred,
    :ginny,
    :harriet,
    :ileana,
    :joseph,
    :kincaid,
    :larry
  ]
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @students),
    do:
      student_names
      |> Enum.sort()
      |> assign_cups(info_string)

  defp assign_cups(students, cups),
    do:
      cups
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.chunk_every(&1, 2))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&List.flatten/1)
      |> Enum.map(&to_cups/1)
      |> build_map(students)

  defp to_cups(cups),
    do:
      cups
      |> Enum.map(&@cups[&1])
      |> List.to_tuple()

  defp build_map(cups, students, acc \\ %{})
  defp build_map([], [], acc), do: acc

  defp build_map([], [student | students], acc),
    do: build_map([], students, Map.put(acc, student, {}))

  defp build_map([cup | cups], [student | students], acc),
    do: build_map(cups, students, Map.put(acc, student, cup))
end
