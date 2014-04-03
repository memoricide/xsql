defmodule XSQL.Field do
  use XSQL.Type
  use XSQL.Constraint

  def __struct__ do
    %{ name:         nil, 
       type:         nil, 
       value:        nil, 
       default:      nil, 
       collation:    nil,
       constraints:  nil }
  end

  def id() do
    %__MODULE__{name: "id", type: type("BIGINT"), constraints: [primary()]}
  end

  def field(name, t) 
    when is_binary(name) and is_atom(t) do
    %__MODULE__{name: name, type: type(t)}
  end

  def field(name, v) 
    when is_binary(name) do
    %__MODULE__{name: name, type: to_type(v)}
  end

  def field(name, t, references: path) do
    %__MODULE__{name: name, type: type(t), constraints: [ references(path) ]}
  end

  # Boilerplate
  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import  unquote(__MODULE__)
    end
  end

end

defimpl XSQL.Protocol, for: XSQL.Field do
  def to_sql(field) do
    IO.inspect "NOT IMPLEMENTED"
  end
end
