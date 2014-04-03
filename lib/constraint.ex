defmodule XSQL.Constraint do

  def __struct__ do
    %{ name:       nil,
       constraint: nil,
       args:       nil,
       params:     nil }
  end

  def references(what) do
    %__MODULE__{constraint: "REFERENCES", params: what}
  end

  def primary(params \\ nil) do
    %__MODULE__{constraint: "PRIMARY KEY", params: params}
  end

  # Boilerplate
  defmacro __using__(_) do
    quote do
      require unquote(__MODULE__)
      import  unquote(__MODULE__)
    end
  end

end

defimpl XSQL.Protocol, for: XSQL.Constraint do
  def to_sql(field) do
    IO.inspect "NOT IMPLEMENTED"
  end
end
