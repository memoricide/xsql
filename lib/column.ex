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

  def nullable(name, x) do 
   column(name, x) |> nullable
  end

  def nullable(col = %__MODULE__{}) do
   %{ col | constraints: Enum.reduce(col.constraints, [], 
                                     fn(x, a) ->
                                       unless x.constraint == "NOT NULL" do
                                         [x|a]
                                       else
                                         a
                                       end
                                     end)}
  end

  def column(name, t) 
    when is_binary(name) and is_atom(t) do
    %__MODULE__{name: name, type: type(t)}
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
