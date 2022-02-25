ExUnit.start()
$if(include_database.truthy)$
Ecto.Adapters.SQL.Sandbox.mode($name;format="word-space,Camel"$.Repo, :manual)
$endif$
