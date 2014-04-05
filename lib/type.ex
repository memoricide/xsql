defmodule XSQL.Type do
  @smallint_min  0-32768
  @smallint_max  32767
  @integer_min   0-2147483648
  @integer_max   2147483647
  @bigint_min    0-9223372036854775808 #lolrofl gives a compile time error w/o 0-
  @bigint_max    9223372036854775807

  @default_varchar_length 255
  @smallest_integer_type  "INTEGER" # What a fucking ugly hack

  def __struct__ do
    %{ type: nil,
       args: nil }
  end

  def type(t, args \\ nil), do: type_do(t, args)
  defp type_do(t, args)
    when is_atom(t) do
    %__MODULE__{type: atom_to_binary(t), args: args}
  end
  defp type_do(t, args) 
    when is_binary(t) do
    %__MODULE__{type: t, args: args}
  end

  # Sadly, to_type function sucks by design. Erlang's type system is not strong enough to 
  # do any magic with it which is fucking sad. If I ever port this code to Haskell even more
  # cool black magic will be included in XSQL library.
  # 
  # Btw, I think that the only legit usage of commentaries for programs is ranting about shit.
  # Which I do. Often and with pleasure.
  def to_type(t = %__MODULE__{}), do: t
  def to_type(v) when is_binary(v) and byte_size(v) <= 255 do
    %__MODULE__{type: "VARCHAR", args: [@default_varchar_length |> integer_to_binary]}
  end
  def to_type(v) when is_binary(v) do
    %__MODULE__{type: "TEXT"}
  end
  def to_type(v) when is_bitstring(v) do
    %__MODULE__{type: "BIT", args: [v |> bit_size |> integer_to_binary]}
  end
  def to_type(v) when is_integer(v) and v >= @smallint_min and v <= @smallint_max do
    %__MODULE__{type: @smallest_integer_type}
  end
  def to_type(v) when is_integer(v) and v >= @integer_min and v <= @integer_max do
    %__MODULE__{type: "INTEGER"}
  end
  def to_type(v) when is_integer(v) and v >= @bigint_min and v <= @bigint_max do
    %__MODULE__{type: "BIGINT"}
  end
  def to_type(v) when is_float(v) do
    %__MODULE__{type: "NUMERIC"}
  end

  def pg_typeof(x) when is_binary(x), do: "#{x}, pg_typeof(#{x}) as #{x}_t"

  # Boilerplate
  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import  unquote(__MODULE__)
    end
  end

end

defimpl XSQL.Protocol, for: XSQL.Type do
  def to_sql(t = %XSQL.Type{ type: type, args: args }) do
    unless type do
      :erlang.error({XSQL.Type, "Type is required in #{inspect t}"})
    end
    if args do
      type <> " (" <> (args |> Enum.join(",")) <> ")"
    else
      type
    end
  end
end
