defmodule XSQL.Table do
  def __struct__ do
    %{ scope:       nil,
       temp:        nil,
       unlogged:    nil,
       new:         true,
       name:        nil,
       of:          nil,
       columns:     nil,
       params:      nil, }
       #with:        nil,
       #on_commit:   nil,
       #tablespace:  nil,
       #like:        nil,
       #constraints: nil }
  end

  defmacro table(name, props) when is_binary(name) and is_list(props) do
    IO.inspect name
    IO.inspect props
    quote do
      ps = unquote(props)
      table =
      if Keyword.has_key? ps, :columns do
        %unquote(__MODULE__){} |> 
          Map.merge(Enum.into(ps, %unquote(__MODULE__){}))
      else
        %unquote(__MODULE__){name: unquote(name), columns: ps}
      end
      IO.inspect table
      %unquote(__MODULE__){ table | name: unquote(name)}
    end
  end

  # Boilerplate
  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import  unquote(__MODULE__)
    end
  end

end

defimpl XSQL.Protocol, for: XSQL.Table do
  def to_sql(t = %XSQL.Table{scope: scope, temp: temp, unlogged: unlogged, new: new, name: name, of: of, columns: columns, params: params}) do
    buff = if scope,       do: ["CREATE", scope],             else: ["CREATE"]
    buff = if temp,        do: buff ++ ["TEMP"],              else: buff
    buff = if unlogged,    do: buff ++ ["UNLOGGED"],          else: buff
    buff = if new,         do: buff ++ ["IF NOT EXISTS"],     else: buff
    buff = if name,        do: buff ++ [ name ],              else: :erlang.error({XSQL.Table, "Name expected #{inspect t}"})
    buff = if of,          do: buff ++ ["OF", of],            else: buff
    buff = if columns,     do: buff ++ ["(", columns_to_sql(columns), ")"], else: buff
    buff = if params,      do: buff ++ params_to_sql(params), else: buff
    buff |> Enum.join(" ")
  end

  defp columns_to_sql(fs) do
    IO.inspect(fs)
    fs |>
    Enum.map(fn(x) -> XSQL.Protocol.to_sql(x) end) |>
    Enum.join ","
  end
  defp params_to_sql(ps) do
    ps |>
    Enum.map(fn(x) -> XSQL.Protocol.to_sql(x) end) |> 
    Enum.join " "
  end
end
