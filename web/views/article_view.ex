defmodule ElmArticles.ArticleView do
  use ElmArticles.Web, :view

  def render("index.json", %{articles: articles}) do
    %{ data: render_many(articles, ElmArticles.ArticleView, "article.json") }
  end

  def render("show.json", %{article: article}) do
    %{ data: render_one(article, ElmArticles.ArticleView, "article.json") }
  end

  def render("article.json", %{article: article}) do
    %{
      id: article.id,
      title: article.title,
      url: article.url,
      posted_by: article.posted_by,
      posted_on: article.posted_on
    }
  end
end
