defmodule XSQL.Column do
  use XSQL.Type
  use XSQL.Constraint

  def __struct__ do
    %{ name:         nil, 
       type:         nil, 
       value:        nil, 
       collation:    nil,
       constraints:  [%XSQL.Constraint{constraint: "NOT NULL"}] }
  end

  # Some “special forms”
  def id() do
    %__MODULE__{name: "id", type: type("BIGINT"), constraints: [primary(), not_null()]}
  end

  def default(name, x, v) do
    column(name, x) |> default(v)
  end

  def default(col = %__MODULE__{}, v) do
    import XSQL.Util
    %{ col | constraints: [XSQL.Constraint.default(v |> to_binary)|
                           Enum.filter(col.constraints, fn(x) -> x.constraint != "DEFAULT" end)] }
  end

  def nullable(name, x) do 
   column(name, x) |> nullable
  end

  def nullable(col = %__MODULE__{}) do
    %{ col | constraints: Enum.filter(col.constraints, fn(x) -> x.constraint != "NOT NULL" end) }
  end

  def column(name, t) 
    when is_binary(name) and is_atom(t) do
    %__MODULE__{name: name, type: type(t)}
  end

  def column(name, t = %XSQL.Type{}) do
    %__MODULE__{name: name, type: t}
  end

  def column(name, v) 
    when is_binary(name) do
    import XSQL.Util
    %__MODULE__{name: name, 
                type: to_type(v), 
                constraints: [ default(v |> to_binary) | %__MODULE__{}.constraints ]}
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
    unless name do
      :erlang.error({XSQL.Colum, "Name is required in #{inspect col}"})
    end
    unless type do
      :erlang.error({XSQL.Colum, "Type is required in #{inspect col}"})
    end
    buff = [name, type |> XSQL.Protocol.to_sql]
    buff = if collation, do: buff ++ ["COLLATE", collation], else: buff
    buff = if constraints, do: buff ++ Enum.map(constraints, &XSQL.Protocol.to_sql(&1)), else: buff
    buff |> Enum.join(" ")
  end
end
