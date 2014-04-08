defmodule XSQL do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    XSQL.Supervisor.start_link
  end

  defmacro __using__(_) do
    sqltools = [XSQL.Table, XSQL.Column, XSQL.Constraint, XSQL.Type]
    tools = for tool <- sqltools do
      quote do
        use unquote(tool)
      end
    end
    quote do
      unquote(tools)
    end
  end
end
