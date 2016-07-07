module Main exposing (..)

import Html exposing (Html, text, div, ul, li, a, h2, input, label, button, br)
import Html.App
import Html.Attributes exposing (class, href, type')
import Html.Events exposing (onClick)

import Components.ArticleList as ArticleList
import Components.ArticleShow as ArticleShow

-- NEW IMPORTS FOR SEPARATE ROUTING
import Router
import Hop.Types exposing (Location)
import Navigation

-- MODEL

type alias Model =
  { articleListModel : ArticleList.Model
  , routerModel : Router.Model -- NEW ADDITION
  , articleShowModel : ArticleShow.Model
  }

-- NOTE THE CHANGES TO THE SIGNATURE AND MODEL
initialModel : Router.Route -> Location -> Model
initialModel route location =
  { articleListModel = ArticleList.initialModel
  , routerModel = (Router.initialModel route location)
  , articleShowModel = ArticleShow.initialModel
  }

-- SEE ABOVE
init : (Router.Route, Location) -> (Model, Cmd Msg)
init (route, location) =
  ( (initialModel route location), Cmd.none )

-- UPDATE

type Msg
  = ArticleListMsg ArticleList.Msg
  | RouterMsg Router.Msg -- ADD A HANDLER FOR ROUTER MSGS
  | ArticleShowMsg ArticleShow.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ArticleListMsg articleMsg ->
      let (updatedModel, cmd) = ArticleList.update articleMsg model.articleListModel
      in ( { model | articleListModel = updatedModel }, Cmd.map ArticleListMsg cmd )
    RouterMsg routerMsg ->
      let (updatedModel, cmd) = Router.update routerMsg model.routerModel
      in ( { model | routerModel = updatedModel }, Cmd.map RouterMsg cmd )
    ArticleShowMsg articleShowMsg ->
      let (updatedModel, cmd) = ArticleShow.update articleShowMsg model.articleShowModel
      in ( { model | articleShowModel = updatedModel }, Cmd.map ArticleShowMsg cmd )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

header : Html Msg
header =
  convertFromRouter (
    ul []
      [ li [] [ a [ onClick (Router.NavigateTo "") ] [ text "Home" ] ]
      , li [] [ a [ onClick (Router.NavigateTo "/articles") ] [ text "Articles" ] ]
      , li [] [ a [ onClick (Router.NavigateTo "/articles/new") ] [ text "New Article" ] ]
      , li [] [ a [ onClick (Router.NavigateTo "/articles/edit") ] [ text "Edit Article" ] ]
      , li [] [ a [ onClick (Router.NavigateTo "/articles/1/show") ] [ text "Show Article" ] ]
      ]
  )

view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ header
    , pageView model
    ]

-- VIEWS

notFoundView : Model -> Html Msg
notFoundView model =
  div []
    [ h2 [] [ text "404: Route Not Found"] ]

welcomeView : Model -> Html Msg
welcomeView model =
  div []
    [ h2 [] [ text "Welcome To ElmArticles" ] ]

articlesView : Model -> Html Msg
articlesView model =
  Html.App.map ArticleListMsg (ArticleList.view model.articleListModel)

newArticleView : Model -> Html Msg
newArticleView model =
  div []
   [ h2 [] [ text "New Article" ]
   , label [] [ text "Title:" ], input [ type' "text" ] []
   , br [] []
   , label [] [ text "URL:" ], input [ type' "text" ] []
   , br [] []
   , button [ class "btn btn-primary" ] [ text "Save" ]
   ]

editArticleView : Model -> Html Msg
editArticleView model =
  div []
   [ h2 [] [ text "Edit Article" ]
   , label [] [ text "Title:" ], input [ type' "text" ] []
   , br [] []
   , label [] [ text "URL:" ], input [ type' "text" ] []
   , br [] []
   , button [ class "btn btn-primary" ] [ text "Save" ]
   ]

convertFromRouter : Html Router.Msg -> Html Msg
convertFromRouter template =
  Html.App.map RouterMsg template

showArticleView : Model -> Int -> Html Msg
showArticleView model articleId =
  Html.App.map ArticleShowMsg (ArticleShow.view model.articleShowModel)

pageView : Model -> Html Msg
pageView model =
  case model.routerModel.route of
    Router.MainRoute ->
      welcomeView model
    Router.ArticlesRoute ->
      articlesView model
    Router.NotFoundRoute ->
      notFoundView model
    Router.EditArticleRoute ->
      editArticleView model
    Router.NewArticleRoute ->
      newArticleView model
    Router.ShowArticleRoute articleId ->
      showArticleView model articleId

-- URLUPDATER THAT CALLS ROUTER.URLUPDATE WITH EXPECTED DATA

urlUpdate : ( Router.Route, Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
  case route of
    Router.ShowArticleRoute articleId ->
      Debug.log "BEGIN"
      ({ model | routerModel = (Router.urlUpdate (route, location) model.routerModel) }, (Cmd.map ArticleShowMsg (ArticleShow.fetchArticle model.articleShowModel)))
    _ ->
      Debug.log "TWO"
      ({ model | routerModel = (Router.urlUpdate (route, location) model.routerModel) }, Cmd.none)


-- MAIN
main : Program Never
main =
  Navigation.program Router.urlParser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }
