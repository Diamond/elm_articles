ExUnit.start

Mix.Task.run "ecto.create", ~w(-r ElmArticles.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r ElmArticles.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(ElmArticles.Repo)

