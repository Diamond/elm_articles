defmodule ElmArticles.ArticleController do
  use ElmArticles.Web, :controller

  def index(conn, _params) do
    data = %{
      articles: [
        %{ id: 1, title: "Article 1", url: "http://google.com", posted_by: "Brandon", posted_on: "06/20/16" },
        %{ id: 2, title: "Article 2", url: "http://google.com", posted_by: "Brandon", posted_on: "06/20/16" },
        %{ id: 3, title: "Article 3", url: "http://google.com", posted_by: "Brandon", posted_on: "06/20/16" },
      ]
    }
    render(conn, "index.json", data)
  end

  def show(conn, %{"id" => _article_id}) do
    data = %{ article: %{ id: 1, title: "Article 1", url: "http://google.com", posted_by: "Brandon", posted_on: "06/20/16" } }
    render(conn, "show.json", data)
  end
end
