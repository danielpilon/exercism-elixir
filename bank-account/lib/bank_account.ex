defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = Agent.start_link(fn -> 0 end)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account), do: account |> exec_with_open_account(fn -> Agent.stop(account) end)

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account), do: account |> exec_with_open_account(fn -> Agent.get(account, & &1) end)

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount),
    do: account |> exec_with_open_account(fn -> Agent.update(account, &(&1 + amount)) end)

  defp exec_with_open_account(account, fun) do
    case Process.alive?(account) do
      true -> fun.()
      false -> {:error, :account_closed}
    end
  end
end
