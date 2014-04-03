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
      if unquote(props)[:fields] do
        IO.puts "Full specification of a table"
      else
        IO.puts "Field-only specification of a table"
      end
    end
  end

end
