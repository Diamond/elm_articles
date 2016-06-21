module Components.ArticleList exposing (..)

import Html exposing (Html, text, ul, li, div, h2, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List
import Article

type alias Model =
  { articles: List Article.Model }

type Msg
  = NoOp
  | Fetch

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (articles, Cmd.none)

articles : Model
articles =
  { articles =
    [ { title = "Article 1", url = "http://google.com", postedBy = "Author", postedOn = "06/20/16" }
    , { title = "Article 2", url = "http://google.com", postedBy = "Author 2", postedOn = "06/20/16" }
    , { title = "Article 3", url = "http://google.com", postedBy = "Author 3", postedOn = "06/20/16" } ] }

renderArticle : Article.Model -> Html a
renderArticle article =
  li [ ] [ Article.view article ]

renderArticles : Model -> List (Html a)
renderArticles articles =
  List.map renderArticle articles.articles

initialModel : Model
initialModel =
  { articles = [] }

view : Model -> Html Msg
view model =
  div [ class "article-list" ]
    [ h2 [] [ text "Article List" ]
    , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Articles" ]
    , ul [] (renderArticles model) ]
