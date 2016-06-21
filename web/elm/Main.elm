module Main exposing (..)

import Html exposing (Html, text, div)
import Html.App
import Html.Attributes exposing (class)

import Components.ArticleList as ArticleList

-- MODEL

type alias Model =
  { articleListModel : ArticleList.Model }

initialModel : Model
initialModel =
  { articleListModel = ArticleList.initialModel }

init : (Model, Cmd Msg)
init =
  ( initialModel, Cmd.none )

-- UPDATE

type Msg
  = ArticleListMsg ArticleList.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ArticleListMsg articleMsg ->
      let (updatedModel, cmd) = ArticleList.update articleMsg model.articleListModel
      in ( { model | articleListModel = updatedModel }, Cmd.map ArticleListMsg cmd )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ Html.App.map ArticleListMsg (ArticleList.view model.articleListModel) ]

-- MAIN

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
