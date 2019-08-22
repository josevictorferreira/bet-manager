defmodule Ecto.Type.ResultBet do
  @behaviour Ecto.Type

  def type, do: :atom

  def cast(atom) when is_atom(atom) do
    {:ok, atom}
  end

  def cast(value) when is_integer(value) do
    {:ok, convert_result_to_atom(value)}
  end

  def cast(_), do: :error

  def load(data) when is_integer(data) do
    case convert_result_to_atom(data) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  def dump(atom) when is_atom(atom) do
    case convert_result_to_integer(atom) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  def dump(_), do: :error

  defp convert_result_to_integer(atom) do
    case atom do
      :lose -> 0
      :win -> 1
      :refund -> 2
      :half_win -> 3
      :half_lost -> 4
      _ -> :error
    end
  end

  defp convert_result_to_atom(value) do
    case value do
      0 -> :lose
      1 -> :win
      2 -> :refund
      3 -> :half_win
      4 -> :half_lost
      _ -> :error
    end
  end
end
