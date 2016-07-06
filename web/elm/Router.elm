module Router exposing (..)

import Components.ArticleList as ArticleList

import Navigation
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)
import Hop.Matchers exposing (..)

-- DEFINE ROUTE UNION TYPES
type Route
  = MainRoute
  | NotFoundRoute
  | ArticlesRoute
  | NewArticleRoute
  | EditArticleRoute
  | ShowArticleRoute Int

-- DEFINE ROUTE MATCHERS
matchers : List (PathMatcher Route)
matchers =
  [ match1 MainRoute ""
  , match1 ArticlesRoute "/articles"
  , match1 NewArticleRoute "/articles/new"
  , match1 EditArticleRoute "/articles/edit"
  , match3 ShowArticleRoute "/articles/" Hop.Matchers.int "/show"
  ]

-- DEFINE ROUTER CONFIG
routerConfig : Config Route
routerConfig =
  { hash = False
  , basePath = ""
  , matchers = matchers
  , notFound = NotFoundRoute
  }

-- MODEL
type alias Model =
  { location : Location
  , route : Route
  }

initialModel : Route -> Location -> Model
initialModel route location =
  Model location route

type Msg =
  NavigateTo String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NavigateTo path ->
      let
        command =
          Debug.log path
          makeUrl routerConfig path
            |> Navigation.newUrl
      in
        (model, command)

urlParser : Navigation.Parser ( Route, Location )
urlParser =
  Navigation.makeParser (.href >> matchUrl routerConfig)

urlUpdate : ( Route, Hop.Types.Location ) -> Model -> Model
urlUpdate ( route, location ) model =
  { model | route = route, location = location }
