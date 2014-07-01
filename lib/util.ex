defmodule XSQL.Util do
  def to_binary(x) when is_binary(x),   do: x
  def to_binary(x) when is_integer(x),  do: :erlang.integer_to_binary(x)
  def to_binary(x) when is_list(x),     do: :erlang.iolist_to_binary(x)
  def to_binary(x) when is_atom(x),     do: :erlang.atom_to_binary(x)
  def to_binary(x),                     do: inspect(x)
end
