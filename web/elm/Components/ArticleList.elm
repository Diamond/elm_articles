module Components.ArticleList exposing (..)

import Html exposing (Html, text, ul, li, div, h2, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List
import Article

-- New for fetching data via HTTP
import Json.Decode as Json exposing ((:=))
import Http
import Task
import Debug

type alias Model =
  { articles: List Article.Model }

type Msg
  = NoOp
  | Fetch
  | FetchSucceed (List Article.Model)
  | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (model, fetchArticles)
    FetchSucceed articleList ->
      (Model articleList, Cmd.none)
    FetchFail error ->
      case error of
        Http.UnexpectedPayload errorMessage ->
          Debug.log errorMessage
          (model, Cmd.none)
        _ ->
          (model, Cmd.none)

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

-- HTTP
fetchArticles : Cmd Msg
fetchArticles =
  let
    url = "/api/articles"
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeArticleFetch url)

-- Fetch the articles out of the "data" key
decodeArticleFetch : Json.Decoder (List Article.Model)
decodeArticleFetch =
  Json.at ["data"] decodeArticleList

-- Then decode the "data" key into a List of Article.Models
decodeArticleList : Json.Decoder (List Article.Model)
decodeArticleList =
  Json.list decodeArticleData

-- Finally, build the decoder for each individual Article.Model
decodeArticleData : Json.Decoder Article.Model
decodeArticleData =
  Json.object4 Article.Model
    ("title" := Json.string)
    ("url" := Json.string)
    ("posted_by" := Json.string)
    ("posted_on" := Json.string)

