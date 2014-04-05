defmodule XSQL do
  use Application.Behaviour

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    XSQL.Supervisor.start_link
  end

  defmacro __using__(opts) do
    hostname = Keyword.get(opts, :hostname, "localhost")
    database = Keyword.get(opts, :database, "xsql")
    username = Keyword.get(opts, :username, "xsql")
    password = Keyword.get(opts, :password, "h4xm3")
    pools = Keyword.get(opts, :pools, [{XSQL.Pool, [
                                          size: 10,
                                          max_overflow: 10
                                        ], [
                                          hostname: hostname,
                                          database: database,
                                          username: username,
                                          password: password ]}])
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
