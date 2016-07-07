module Components.ArticleShow exposing (..)

import Html exposing (Html, text, ul, li, div, h2, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick, on)
import Article

-- New for fetching data via HTTP
import Json.Decode as Json exposing ((:=))
import Http
import Task
import Debug

type alias Model =
  { article: Article.Model
  , id: Int
  }

type Msg
  = NoOp
  | Fetch
  | FetchSucceed Article.Model
  | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    Fetch ->
      (model, fetchArticle model)
    FetchSucceed article ->
      ({ model | article = article }, Cmd.none)
    FetchFail error ->
      case error of
        Http.UnexpectedPayload errorMessage ->
          Debug.log errorMessage
          (model, Cmd.none)
        _ ->
          (model, Cmd.none)

renderArticle : Article.Model -> Html a
renderArticle article =
  case article.id of
    0 ->
      li [] [ text "No article loaded yet" ]
    _ ->
      li [ ] [ Article.view article ]

initialModel : Model
initialModel =
  { article = (Article.Model 0 "" "" "" "")
  , id = 0
  }

view : Model -> Html Msg
view model =
  div [ class "article-show" ]
    [ h2 [] [ text "Article Display" ]
    , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Article" ]
    , ul [] [(renderArticle model.article)] ]

-- HTTP
fetchArticle : Model -> Cmd Msg
fetchArticle model =
  let
    url = ("/api/articles/" ++ (toString model.id))
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeArticleFetch url)

-- Fetch the articles out of the "data" key
decodeArticleFetch : Json.Decoder Article.Model
decodeArticleFetch =
  Json.at ["data"] decodeArticleData

-- Finally, build the decoder for each individual Article.Model
decodeArticleData : Json.Decoder Article.Model
decodeArticleData =
  Json.object5 Article.Model
    ("id" := Json.int)
    ("title" := Json.string)
    ("url" := Json.string)
    ("posted_by" := Json.string)
    ("posted_on" := Json.string)
