defmodule XSQL.Constraint do

  def __struct__ do
    %{ name:       nil,
       constraint: nil,
       args:       nil,
       params:     nil }
  end

  def references(what) do
    %__MODULE__{constraint: "REFERENCES", params: [what]}
  end

  def primary(params \\ [])
  when is_list(params) do
    %__MODULE__{constraint: "PRIMARY KEY", params: params}
  end

  def not_null() do
    %__MODULE__{constraint: "NOT NULL"}
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
  def to_sql(cstr = %XSQL.Constraint{name: name, constraint: constraint, args: args, params: params}) do
    IO.inspect cstr
    unless constraint do
      :erlang.error({XSQL.Constraint, "Constraint type is required in #{IO.inspect cstr}"})
    end
    buff = if name, do: ["CONSTRAINT", name], else: []
    buff = buff ++ [constraint]
    buff = if args, do: buff ++ ["("|(args |> Enum.join(","))] ++ [")"], else: buff # Omg this is so fucking ugly
    buff = if params, do: buff ++ params, else: buff
    buff |> Enum.join(" ")
  end
end
