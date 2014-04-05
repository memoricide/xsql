defprotocol XSQL.Protocol do
  def to_sql(thing)
end

for toimpl <- [ BitString, Integer, Float ] do
  quote do 
    defimpl XSQL.Protocol, for: unquote(toimpl) do
      def to_sql(x), do: x |> XSQL.Util.to_binary
    end
  end
end
