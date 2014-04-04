defmodule XSQL.Table do
  def __struct__ do
    %{ name:        nil,
       fields:      nil,
       constraints: nil,
       tablespace:  nil,
       args:        nil,
       specifiers:  nil,
       types:       nil,
       params:      nil,
       context:     nil }
  end

  defmacro table(name, props) when is_binary(name) and is_list(props) do
    IO.inspect name
    IO.inspect props
    quote do
      ps = unquote(props)
      if Keyword.has_key? ps, :fields do
        IO.puts "Full specification of a table"
        IO.inspect Enum.into(ps, %unquote(__MODULE__){})
      else
        IO.puts "Partial specification of a table"
        IO.inspect %unquote(__MODULE__){fields: ps}
      end
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
