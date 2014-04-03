defmodule XSQL.Column do
  use XSQL.Type
  use XSQL.Constraint

  def __struct__ do
    %{ name:         nil, 
       type:         nil, 
       value:        nil, 
       collation:    nil,
       constraints:  nil }
  end

  # Some “special forms”
  def id() do
    %__MODULE__{name: "id", type: type("BIGINT"), constraints: [primary(), not_null()]}
  end

  def column(name, t) 
    when is_binary(name) and is_atom(t) do
    %__MODULE__{name: name, type: type(t)}
  end

  def column(name, v) 
    when is_binary(name) do
    %__MODULE__{name: name, type: to_type(v)}
  end

  def column(name, t, references: path) do
    %__MODULE__{name: name, type: type(t), constraints: [ references(path), not_null() ]}
  end

  # Boilerplate
  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import  unquote(__MODULE__)
    end
  end

end

defimpl XSQL.Protocol, for: XSQL.Column do
  def to_sql(col = %XSQL.Column{name: name, type: type, collation: collation, constraints: constraints}) do
    IO.inspect col
    unless name do
      :erlang.error({XSQL.Colum, "Name is required in #{IO.inspect col}"})
    end
    unless type do
      :erlang.error({XSQL.Colum, "Type is required in #{IO.inspect col}"})
    end
    buff = [name, type |> XSQL.Protocol.to_sql]
    buff = if collation, do: buff ++ ["COLLATE", collation], else: buff
    buff = if constraints, do: buff ++ Enum.map(constraints, &XSQL.Protocol.to_sql(&1)), else: buff
    buff |> Enum.join(" ")
  end
end
