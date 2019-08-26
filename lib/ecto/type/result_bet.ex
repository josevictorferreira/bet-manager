defmodule Ecto.Type.ResultBet do
  @behaviour Ecto.Type

  def type, do: :integer

  def cast(atom) when is_atom(atom) do
    IO.inspect("Entrou cast is atom")
    {:ok, atom}
  end

  def cast(value) when is_integer(value) do
    IO.inspect("Entrou cast is integer")
    {:ok, convert_result_to_atom(value)}
  end

  def cast(value) when is_binary(value) do
    IO.inspect("Entrou cast is binary")
    IO.inspect(value)
    {:ok, convert_result_to_atom(value)}
  end

  def cast(nil) do
    IO.inspect("Entrou cast is nil")
    {:ok, :undefined}
  end

  def cast(_), do: :error

  def load(data) do
    IO.inspect("Entrou no load is integer")
    IO.inspect(data)

    case convert_result_to_atom(data) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  def dump(atom) when is_atom(atom) do
    IO.inspect("Entrou dump is atom")
    IO.inspect(atom)

    case convert_result_to_integer(atom) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  def dump(value) do
    IO.inspect("Dump default")
    IO.inspect(value)
    :error
  end

  def dump(_), do: :error

  defp convert_result_to_integer(atom) do
    case atom do
      :undefined -> nil
      :lose -> 0
      :win -> 1
      :refund -> 2
      :half_win -> 3
      :half_lost -> 4
      _ -> :error
    end
  end

  defp convert_result_to_atom(value) when is_binary(value) do
    case value do
      "undefined" -> :undefined
      "lose" -> :lose
      "win" -> :win
      "refund" -> :refund
      "half win" -> :half_win
      "half lost" -> :half_lost
      _ -> :error
    end
  end

  defp convert_result_to_atom(value) do
    case value do
      nil -> :undefined
      0 -> :lose
      1 -> :win
      2 -> :refund
      3 -> :half_win
      4 -> :half_lost
      _ -> :error
    end
  end
end
