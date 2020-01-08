defmodule SecretHandshake do
  use Bitwise

  @handshakes %{
    0b1 => "wink",
    0b10 => "double blink",
    0b100 => "close your eyes",
    0b1000 => "jump"
  }

  @reverse_event 0b10000

  defp match_event?({event, _}, code) do
    Bitwise.band(event, code) > 0
  end

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    commands =
      @handshakes
      |> Enum.filter(&match_event?(&1, code))
      |> Enum.map(fn {_, v} -> v end)

    if Bitwise.band(@reverse_event, code) > 0 do
      Enum.reverse(commands)
    else
      commands
    end
  end
end
